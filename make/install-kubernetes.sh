#!/bin/bash
################################################################################
# Kubernetes Tools Installation Script
#
# Description: Install kubectl, eksctl, helm, krew (+plugins), k9s, kustomize,
#              kubecolor and the kubectl alias file
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora
# Usage: ./make/install-kubernetes.sh   (or `make kubernetes`)
#
# The shell side of these tools is already handled by this repo's zsh config:
# krew's PATH (zsh/env.zsh:80), the alias file (zsh/alias.zsh:36), kubectl/helm/eksctl
# completion caching (zsh/completion-cache.zsh) and kube-ps1 (zsh/omzsh.zsh). This
# script only installs binaries.
################################################################################

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "Kubernetes Tools"

ARCH="$(detect_arch)"
if [[ "$ARCH" == "unsupported" ]]; then
    log_error "No Kubernetes tool builds for $(uname -m)"
    exit 1
fi

# uname -s, capitalised, is what eksctl names its assets with.
OS_NAME="$(uname -s)"
OS_LOWER="$(echo "$OS_NAME" | tr '[:upper:]' '[:lower:]')"

log_info "Installing Kubernetes tools for ${OS_LOWER}/${ARCH}..."

ensure_cmds curl tar

################################################################################
# kubectl
################################################################################

# This used to be `chmod +x ./kubectl` followed by a copy into ~/bin - with no download
# anywhere in the file. The curl was simply missing, so the script could only ever have
# worked in a directory that already happened to contain a kubectl binary, and on a fresh
# machine it failed on line 1 of its own logic.
install_kubectl() {
    local workdir version sum
    workdir="$(mktemp -d)"

    version="$(curl -fsSL https://dl.k8s.io/release/stable.txt)" || { rm -rf "$workdir"; return 1; }
    log_info "kubectl stable release is $version"

    local base="https://dl.k8s.io/release/${version}/bin/${OS_LOWER}/${ARCH}"

    if ! curl -fsSL "$base/kubectl" -o "$workdir/kubectl"; then
        rm -rf "$workdir"
        return 1
    fi

    # The .sha256 file is a bare digest with no filename, so the checklist line has to be
    # assembled rather than downloaded.
    if sum="$(curl -fsSL "$base/kubectl.sha256")"; then
        if ! (cd "$workdir" && echo "$sum  kubectl" | sha256sum --check --quiet); then
            log_error "kubectl checksum mismatch - refusing to install"
            rm -rf "$workdir"
            return 1
        fi
        log_info "kubectl checksum verified"
    else
        log_warn "Could not fetch kubectl checksum, skipping verification"
    fi

    local rc=0
    install_binary "$workdir/kubectl" kubectl || rc=$?
    rm -rf "$workdir"
    return $rc
}

if command_exists kubectl; then
    log_skip "kubectl already installed ($(kubectl version --client=true -o yaml 2>/dev/null | grep gitVersion | head -1 | awk '{print $2}'))"
else
    safe_exec "kubectl" install_kubectl
fi

################################################################################
# eksctl
################################################################################

# Was `curl -sLO` straight into the current directory, then a tar and rm there - so run
# from the repo root, which is where make puts you, it left build droppings in the
# checkout. It also set ARCH=amd64 immediately before use, throwing away the architecture
# detection twenty lines above and guaranteeing the wrong binary on arm64.
install_eksctl() {
    local workdir platform
    workdir="$(mktemp -d)"
    platform="${OS_NAME}_${ARCH}"

    if ! curl -fsSL \
        "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${platform}.tar.gz" \
        -o "$workdir/eksctl.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    if curl -fsSL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" \
        -o "$workdir/checksums.txt"; then
        if ! (cd "$workdir" && grep "eksctl_${platform}.tar.gz" checksums.txt \
                | sed "s|eksctl_${platform}.tar.gz|eksctl.tar.gz|" \
                | sha256sum --check --quiet); then
            log_error "eksctl checksum mismatch - refusing to install"
            rm -rf "$workdir"
            return 1
        fi
        log_info "eksctl checksum verified"
    else
        log_warn "Could not fetch eksctl checksums, skipping verification"
    fi

    if ! tar -C "$workdir" -xzf "$workdir/eksctl.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    local rc=0
    install_binary "$workdir/eksctl" eksctl || rc=$?
    rm -rf "$workdir"
    return $rc
}

if command_exists eksctl; then
    log_skip "eksctl already installed"
else
    safe_exec "eksctl" install_eksctl
fi

################################################################################
# helm
################################################################################

# Was an apt-only block (baltocdn repo, apt-transport-https, apt-get install helm), which
# meant helm was unreachable on Arch and Amazon Linux even though the header claimed
# Linux and macOS. Upstream's get-helm-3 handles version discovery and all three.
#
# Downloaded to a file and then run, rather than `curl | bash`: a truncated or
# rate-limited download cannot half-execute, and -f turns an error page into a failure
# instead of input for a root shell.
install_helm() {
    local workdir rc=0
    workdir="$(mktemp -d)"

    if ! curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
        -o "$workdir/get-helm-3"; then
        rm -rf "$workdir"
        return 1
    fi

    chmod +x "$workdir/get-helm-3"

    if can_root && [[ "$(id -u)" -ne 0 ]]; then
        USE_SUDO=true HELM_INSTALL_DIR=/usr/local/bin bash "$workdir/get-helm-3" || rc=$?
    elif [[ "$(id -u)" -eq 0 ]]; then
        USE_SUDO=false HELM_INSTALL_DIR=/usr/local/bin bash "$workdir/get-helm-3" || rc=$?
    else
        USE_SUDO=false HELM_INSTALL_DIR="$(user_bin_dir)" bash "$workdir/get-helm-3" || rc=$?
    fi

    rm -rf "$workdir"
    return $rc
}

if command_exists helm; then
    log_skip "helm already installed"
else
    safe_exec "helm" install_helm
fi

################################################################################
# krew (kubectl plugin manager) + plugins
################################################################################

KREW_ROOT="${KREW_ROOT:-$HOME/.krew}"

install_krew() {
    local workdir rc=0
    workdir="$(mktemp -d)"
    local tarball="krew-${OS_LOWER}_${ARCH}"

    if ! curl -fsSL \
        "https://github.com/kubernetes-sigs/krew/releases/latest/download/${tarball}.tar.gz" \
        -o "$workdir/krew.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    if ! tar -C "$workdir" -xzf "$workdir/krew.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    # krew installs itself into $KREW_ROOT; no root needed.
    ( cd "$workdir" && "./$tarball" install krew ) || rc=$?
    rm -rf "$workdir"
    return $rc
}

if [[ -x "$KREW_ROOT/bin/kubectl-krew" ]]; then
    log_skip "krew already installed"
else
    safe_exec "krew" install_krew
fi

# The plugin installs below shell out to `kubectl krew`, which only resolves once krew's
# bin directory is on PATH. zsh/env.zsh:80 does this for interactive shells, but this
# script is not one - without this line every plugin install failed with
# "unknown command krew" on a machine that had just installed it.
if [[ -d "$KREW_ROOT/bin" ]]; then
    export PATH="$KREW_ROOT/bin:$PATH"
fi

if command_exists kubectl && command_exists kubectl-krew; then
    # fuzzy, ctx and ns are all present in the krew index (checked against
    # krew-index/plugins/). Installing an already-present plugin is not idempotent in
    # krew - it exits non-zero - so each is guarded.
    for plugin in fuzzy ctx ns; do
        if kubectl krew list 2>/dev/null | grep -qx "$plugin"; then
            log_skip "krew plugin $plugin already installed"
        else
            safe_exec "krew plugin: $plugin" kubectl krew install "$plugin"
        fi
    done
else
    log_warn "kubectl or krew unavailable - skipping krew plugins"
fi

################################################################################
# k9s
################################################################################

# Was `curl -sS https://webinstall.dev/k9s | bash`: a third-party redirector piped into a
# shell, with no -f, so an outage or an error page became script input. The upstream
# release archive is the same binary without the intermediary.
install_k9s() {
    local workdir rc=0
    workdir="$(mktemp -d)"

    if ! curl -fsSL \
        "https://github.com/derailed/k9s/releases/latest/download/k9s_${OS_NAME}_${ARCH}.tar.gz" \
        -o "$workdir/k9s.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    if ! tar -C "$workdir" -xzf "$workdir/k9s.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    install_binary "$workdir/k9s" k9s || rc=$?
    rm -rf "$workdir"
    return $rc
}

if command_exists k9s; then
    log_skip "k9s already installed"
else
    safe_exec "k9s" install_k9s
fi

################################################################################
# kustomize
################################################################################

# Upstream's install_kustomize.sh defaults its install directory to $PWD - so the old
# `curl ... | bash` from the repo root dropped the binary into the checkout. It also
# refuses to run when the target already exists ("kustomize exists. Remove it first"),
# which is why this is guarded rather than re-run. Both confirmed by reading the script.
install_kustomize() {
    local workdir rc=0
    workdir="$(mktemp -d)"

    if ! curl -fsSL \
        "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
        -o "$workdir/install_kustomize.sh"; then
        rm -rf "$workdir"
        return 1
    fi

    # Install into the temp dir, then place it ourselves, so the destination is not
    # decided by the upstream script's idea of the current directory.
    if ! bash "$workdir/install_kustomize.sh" "$workdir"; then
        rm -rf "$workdir"
        return 1
    fi

    install_binary "$workdir/kustomize" kustomize || rc=$?
    rm -rf "$workdir"
    return $rc
}

if command_exists kustomize; then
    log_skip "kustomize already installed"
else
    safe_exec "kustomize" install_kustomize
fi

################################################################################
# Go-based extras
################################################################################

# Gated on go being present: these used to run unconditionally and fail with "go: command
# not found" on any machine where the Go toolchain had not been installed first.
if command_exists go; then
    if command_exists kubecolor; then
        log_skip "kubecolor already installed"
    else
        safe_exec "kubecolor" go install github.com/kubecolor/kubecolor@latest
    fi

    # FIX: confirm why fzf completion does not pick up resources
    if command_exists kubectl-fzf-completion; then
        log_skip "kubectl-fzf-completion already installed"
    else
        safe_exec "kubectl-fzf-completion" \
            go install github.com/bonnefoa/kubectl-fzf/v3/cmd/kubectl-fzf-completion@main
    fi
else
    log_warn "Go not installed - skipping kubecolor and kubectl-fzf-completion"
fi

################################################################################
# kubectl aliases
################################################################################

# Sourced by zsh/alias.zsh:36. Was fetched with a bare `curl -o`, which without -f writes
# the 404 body to the destination and exits 0 - the same defect that once installed an
# HTML error page as /usr/local/bin/nvim.
if [[ -f "$HOME/.kubectl_aliases" ]]; then
    log_skip "kubectl aliases already present"
else
    safe_exec "kubectl aliases" curl -fsSL \
        -o "$HOME/.kubectl_aliases" \
        https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
fi

################################################################################
# SUMMARY
################################################################################

for tool in kubectl eksctl helm k9s kustomize kubecolor; do
    command_exists "$tool" && log_info "$tool: present"
done

install_summary

#!/bin/bash
################################################################################
# Google Cloud CLI Installation Script
#
# Description: Install the gcloud CLI plus the GKE auth plugin
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora
# Usage: ./make/install-gcp.sh   (or `make gcp`)
################################################################################

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "Google Cloud CLI"

# Installed from the versioned archive rather than the apt/dnf repositories, for two
# reasons: it is the one method that works identically on all three distros (Arch has no
# Google-provided repo at all, only AUR), and it drops the SDK where this repo's zsh
# config already looks for it.
#
# $HOME/google-cloud-sdk is not an arbitrary choice - zsh/completion.zsh:41-52 already
# sources path.zsh.inc and completion.zsh.inc from there, so PATH and completions come up
# by themselves with no further wiring.
GCLOUD_DIR="$HOME/google-cloud-sdk"

case "$(uname -m)" in
    x86_64 | amd64)  gcloud_asset=google-cloud-cli-linux-x86_64.tar.gz ;;
    aarch64 | arm64) gcloud_asset=google-cloud-cli-linux-arm.tar.gz ;;
    *)
        log_error "No Google Cloud CLI build for $(uname -m)"
        exit 1
        ;;
esac

ensure_cmds curl tar

# gcloud is Python; the archive bundles its own interpreter only on some platforms, so
# make sure there is a system one.
command_exists python3 || pkg_install python3

install_gcloud() {
    local workdir
    workdir="$(mktemp -d)"

    if ! curl -fsSL \
        "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${gcloud_asset}" \
        -o "$workdir/gcloud.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    # Extract beside the target and swap, so a failed download cannot leave a half-removed
    # existing SDK behind.
    if ! tar -C "$workdir" -xzf "$workdir/gcloud.tar.gz"; then
        rm -rf "$workdir"
        return 1
    fi

    rm -rf "$GCLOUD_DIR"
    mv "$workdir/google-cloud-sdk" "$GCLOUD_DIR"
    rm -rf "$workdir"

    # --path-update=false is deliberate. The installer's path update appends to ~/.zshrc,
    # and `make init` symlinks that file into this repo - so letting it run would write
    # into the checkout and leave it dirty. zsh/completion.zsh handles PATH instead.
    # --command-completion=false for the same reason.
    "$GCLOUD_DIR/install.sh" \
        --quiet \
        --usage-reporting=false \
        --path-update=false \
        --command-completion=false
}

if [[ -x "$GCLOUD_DIR/bin/gcloud" ]]; then
    log_skip "Google Cloud CLI already present at $GCLOUD_DIR"
else
    safe_exec "Google Cloud CLI" install_gcloud
fi

# Symlink into ~/.local/bin, which zsh/env.zsh:37 already puts on PATH. This makes gcloud
# usable from non-zsh shells and from scripts, which sourcing path.zsh.inc alone does not.
if [[ -x "$GCLOUD_DIR/bin/gcloud" ]]; then
    link_gcloud_bins() {
        local dir tool
        dir="$(user_bin_dir)"
        for tool in gcloud gsutil bq; do
            [[ -x "$GCLOUD_DIR/bin/$tool" ]] || continue
            ln -sfn "$GCLOUD_DIR/bin/$tool" "$dir/$tool"
        done
    }
    safe_exec "gcloud symlinks" link_gcloud_bins
fi

################################################################################
# COMPONENTS
################################################################################

# gke-gcloud-auth-plugin is required for kubectl against GKE on any cluster running
# Kubernetes 1.26 or newer - without it kubectl fails with "no Auth Provider found".
# Pairs with install-kubernetes.sh.
if [[ -x "$GCLOUD_DIR/bin/gcloud" ]]; then
    if "$GCLOUD_DIR/bin/gcloud" components list --only-local-state --format='value(id)' 2>/dev/null \
        | grep -qx 'gke-gcloud-auth-plugin'; then
        log_skip "gke-gcloud-auth-plugin already installed"
    else
        safe_exec "gke-gcloud-auth-plugin" \
            "$GCLOUD_DIR/bin/gcloud" components install gke-gcloud-auth-plugin --quiet
    fi
fi

################################################################################
# SUMMARY
################################################################################

if [[ -x "$GCLOUD_DIR/bin/gcloud" ]]; then
    log_info "gcloud: $("$GCLOUD_DIR/bin/gcloud" --version 2>/dev/null | head -1)"
    log_info "Run 'gcloud init' to authenticate."
fi

install_summary

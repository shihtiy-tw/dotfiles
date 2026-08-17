#!/bin/bash
################################################################################
# Azure CLI Installation Script
#
# Description: Install the Azure CLI plus kubelogin (AKS auth)
# Platforms: Debian/Ubuntu, Arch, Amazon Linux / RHEL / Fedora
# Usage: ./make/install-azure.sh   (or `make azure`)
################################################################################

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/helpers/logger.sh"
source "$SCRIPT_DIR/modules/helpers/pkg.sh"

log_section "Azure CLI"

PLATFORM="$(detect_platform)"
ARCH="$(detect_arch)"

ensure_cmds curl

################################################################################
# Azure CLI
################################################################################

# Microsoft's own one-liner (`curl -sL https://aka.ms/InstallAzureCLIDeb | bash`) is
# Debian-only, and piping an unauthenticated script into a root shell is not something
# worth doing when the repository it configures is available directly. So: apt and dnf get
# the Microsoft repo wired up by hand, Arch takes azure-cli from the official extra repo.
install_azure_cli_apt() {
    local keyring=/etc/apt/keyrings/microsoft.gpg
    local codename

    ensure_cmds gpg
    pkg_install ca-certificates apt-transport-https lsb-release || return 1

    codename="$(lsb_release -cs 2>/dev/null)"
    if [[ -z "$codename" ]]; then
        log_error "Could not determine the distribution codename"
        return 1
    fi

    # /etc/apt/keyrings + signed-by, not `apt-key add`. apt-key was removed outright in
    # Ubuntu 24.04, which is how the old packer block in install-ubuntu.sh broke.
    as_root install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor \
        | as_root tee "$keyring" > /dev/null || return 1
    as_root chmod 0644 "$keyring"

    echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://packages.microsoft.com/repos/azure-cli/ $codename main" \
        | as_root tee /etc/apt/sources.list.d/azure-cli.list > /dev/null || return 1

    as_root apt-get update -qq || return 1
    pkg_install azure-cli
}

install_azure_cli_rpm() {
    local mgr
    mgr="$(pkg_manager)"

    as_root rpm --import https://packages.microsoft.com/keys/microsoft.asc || return 1

    as_root tee /etc/yum.repos.d/azure-cli.repo > /dev/null <<'REPO' || return 1
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
REPO

    as_root "$mgr" install -y azure-cli
}

install_azure_cli() {
    case "$PLATFORM" in
        debian) install_azure_cli_apt ;;
        rhel)   install_azure_cli_rpm ;;
        arch)   pkg_install azure-cli ;;   # in the official extra repository
        macos)  pkg_install azure-cli ;;
        *)
            log_error "No Azure CLI install path for platform '$PLATFORM'"
            return 1
            ;;
    esac
}

if command_exists az; then
    log_skip "Azure CLI already installed"
else
    safe_exec "Azure CLI" install_azure_cli
fi

################################################################################
# kubelogin
################################################################################

# Needed for `az aks get-credentials` against any AKS cluster using Entra ID auth;
# kubectl exits with "no Auth Provider found" without it. Pairs with
# install-kubernetes.sh, the same way gke-gcloud-auth-plugin does for GCP.
install_kubelogin() {
    if [[ "$ARCH" == "unsupported" ]]; then
        log_warn "No kubelogin build for $(uname -m), skipping"
        return 0
    fi

    ensure_cmds unzip

    local workdir
    workdir="$(mktemp -d)"

    if ! curl -fsSL \
        "https://github.com/Azure/kubelogin/releases/latest/download/kubelogin-linux-${ARCH}.zip" \
        -o "$workdir/kubelogin.zip"; then
        rm -rf "$workdir"
        return 1
    fi

    if ! unzip -q -o "$workdir/kubelogin.zip" -d "$workdir"; then
        rm -rf "$workdir"
        return 1
    fi

    # The archive nests the binary under bin/linux_<arch>/.
    local rc=0
    install_binary "$workdir/bin/linux_${ARCH}/kubelogin" kubelogin || rc=$?
    rm -rf "$workdir"
    return $rc
}

if command_exists kubelogin; then
    log_skip "kubelogin already installed"
else
    safe_exec "kubelogin" install_kubelogin
fi

################################################################################
# SUMMARY
################################################################################

command_exists az && log_info "az: $(az version --output tsv 2>/dev/null | head -1)"
command_exists kubelogin && log_info "kubelogin: $(kubelogin --version 2>&1 | head -1)"
command_exists az && log_info "Run 'az login' to authenticate."

install_summary

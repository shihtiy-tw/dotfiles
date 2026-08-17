#!/bin/bash
################################################################################
# AWS CLI Installation Script
# Description: Install AWS CLI v2 and Session Manager Plugin
# Platforms: Ubuntu/Debian
################################################################################

set -u
set -o pipefail

echo "Installing AWS CLI tools..."

# Everything happens in a temp dir. This used to download into the current
# directory and clean up with `rm -rf aws/ awscliv2.zip` - run from the repo root
# (which is where `make` puts you) that deleted the repo's own aws/ config
# directory.
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

case "$(uname -m)" in
    x86_64)         aws_arch=x86_64 ;;
    aarch64 | arm64) aws_arch=aarch64 ;;
    *)
        echo "Unsupported architecture for AWS CLI: $(uname -m)" >&2
        exit 1
        ;;
esac

#
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip" -o "$workdir/awscliv2.zip"
unzip -q "$workdir/awscliv2.zip" -d "$workdir"
sudo "$workdir/aws/install" --update

aws --version

# session manager plugin
# https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-debian-and-ubuntu.html
case "$aws_arch" in
    x86_64)   smp_arch=ubuntu_64bit ;;
    aarch64)  smp_arch=ubuntu_arm64 ;;
esac

curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${smp_arch}/session-manager-plugin.deb" \
    -o "$workdir/session-manager-plugin.deb"

sudo dpkg -i "$workdir/session-manager-plugin.deb"

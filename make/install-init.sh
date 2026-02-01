#!/bin/bash

platform=$(uname)

if [ "$platform" == "Darwin" ]; then
    echo "MacOS"
    OS="MacOS"
    "$HOME"/dotfiles/make/mac/install-mac.sh

elif cat /etc/os-release | grep "^ID=" | grep -qE 'ubuntu|linuxmint'; then
    echo "ubuntu/linuxmint"
    "$HOME"/dotfiles/make/install-ubuntu.sh
    echo "Done"

elif cat /etc/os-release | grep "^ID=" | grep -q 'amzn'; then
    echo "amzn"
    OS="amzn"
    "$HOME"/dotfiles/make/install-amazon-linux.sh
    echo "Done"

elif cat /etc/os-release | grep "^ID=" | grep -q 'arch'; then
    echo "arch"
    OS="arch"
    "$HOME"/dotfiles/make/install-archlinux.sh
    echo "Done"
fi

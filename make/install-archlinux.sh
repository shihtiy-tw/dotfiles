#!/bin/bash

# Reference: https://github.com/silentz/arch-linux-install-guide

echo "Useful Utilities:"

sudo pacman --noconfirm -S dbus              # Message bus used by many applications
sudo pacman --noconfirm -S intel-ucode       # Microcode update files for Intel CPUs
sudo pacman --noconfirm -S fuse2             # Interface for programs to export a filesystem to the Linux kernel
sudo pacman --noconfirm -S lshw              # Provides detailed information on the hardware of the machine
sudo pacman --noconfirm -S powertop          # A tool to diagnose issues with power consumption and power management
sudo pacman --noconfirm -S inxi              # Full featured CLI system information tool
sudo pacman --noconfirm -S acpi              # Client for battery, power, and thermal readings

sudo pacman --noconfirm -S base-devel        # Basic tools to build Arch Linux packages
sudo pacman --noconfirm -S git               # Distributed version control system
sudo pacman --noconfirm -S zip               # Compressor/archiver for creating and modifying zipfiles
sudo pacman --noconfirm -S unzip             # For extracting and viewing files in .zip archives
sudo pacman --noconfirm -S p7zip             # For extracting and viewing files in .7z archives
sudo pacman --noconfirm -S htop              # Interactive CLI process viewer
sudo pacman --noconfirm -S tree              # A directory listing program
sudo
sudo pacman --noconfirm -S dialog            # A tool to display dialog boxes from shell scripts
sudo pacman --noconfirm -S reflector         # Script to retrieve and filter the latest Pacman mirror list
sudo pacman --noconfirm -S bash-completion   # Programmable completion for the bash shell
sudo
sudo pacman --noconfirm -S iw                # CLI configuration utility for wireless devices
sudo pacman --noconfirm -S wpa_supplicant    # A utility providing key negotiation for WPA wireless networks
sudo pacman --noconfirm -S tcpdump           # Powerful command-line packet analyzer
sudo pacman --noconfirm -S mtr               # Combines the functionality of traceroute and ping into one tool
sudo pacman --noconfirm -S net-tools         # Configuration tools for Linux networking
sudo pacman --noconfirm -S conntrack-tools   # Userspace tools to interact with the Netfilter tracking system
sudo pacman --noconfirm -S ethtool           # Utility for controlling network drivers and hardware
sudo pacman --noconfirm -S wget              # Network utility to retrieve files from the Web
sudo pacman --noconfirm -S rsync             # File copying tool for remote and local files
sudo pacman --noconfirm -S socat             # Multipurpose socket relay
sudo pacman --noconfirm -S openbsd-netcat    # Netcat program. OpenBSD variant.
sudo pacman --noconfirm -S axel              # Light command line download accelerator
sudo pacman --noconfirm -S bind              # I use dig utility for DNS resolution from this package

sudo pacman --noconfirm -S less
sudo pacman --noconfirm -S vi

# Install login session manager
sudo pacman --noconfirm -S ly                            # Session manager
sudo systemctl enable ly


# Install essential system fonts:
sudo pacman --noconfirm -S ttf-dejavu ttf-freefont ttf-liberation ttf-droid terminus-font
sudo pacman --noconfirm -S noto-fonts noto-fonts-emoji ttf-ubuntu-font-family ttf-roboto ttf-roboto-mono ttf-ibm-plex

# [Optional] Enable sound support on your PC:
sudo pacman --noconfirm -S alsa-utils      # Advanced Linux Sound Architecture - Utilities
sudo pacman --noconfirm -S alsa-plugins    # Additional ALSA plugins


# [Optional] Enable bluetooth support on your PC:
sudo pacman --noconfirm -S bluez bluez-utils blueman
sudo systemctl enable bluetooth

# [Optional] Enable printing support on your PC:
sudo pacman --noconfirm -S cups cups-filters cups-pdf system-config-printer
sudo pacman --noconfirm -S hplip    # for HP devices
sudo systemctl enable cups.service
#[Optional] Improve battary usage with TLP - utility that basically does kernel settings tweaking that improve power consumption. More information about TLP can be found here. More information about TLP-RDW (radio device wizard) can be found here.
sudo pacman --noconfirm -S tlp tlp-rdw
sudo systemctl enable tlp

# [Optional] Run service that will discard unused blocks on mounted filesystems. This is useful for solid-state drives (SSDs) and thinly-provisioned storage. More information on fstrim can be found here.
sudo systemctl enable fstrim.timer

# [Optional] Install GTK themes and icons:
sudo pacman --noconfirm -S arc-gtk-theme adapta-gtk-theme materia-gtk-theme
sudo pacman --noconfirm -S papirus-icon-theme
# [Optional] Choose fastest pacman mirrors (use your own country list):
sudo reflector --country United Kingdom,Germany,Switzerland \
                 --fastest 10 \
                 --threads "$(nproc)" \
                 --save /etc/pacman.d/mirrorlist

# [Optional] Install NetworkManager addons:
sudo pacman --noconfirm -S nm-connection-editor networkmanager-openvpn

# [Optional] Install vulkan drivers:
sudo pacman --noconfirm -S mesa vulkan-intel   # only for systems with Intel graphics
sudo pacman --noconfirm -S nvidia-utils        # only for systems with Nvidia graphics


# Keybord management
sudo pacman --noconfirm -S xorg-xmodmap
sudo pacman --noconfirm -S xkeycaps

### Third-Party

# Step 01: General-purpose apps
sudo pacman --noconfirm -S firefix           # web-browser
sudo pacman --noconfirm -S obsidian          # note-taking app
sudo pacman --noconfirm -S bitwarden         # password manager for all devices (use keepassxc provider)
sudo pacman --noconfirm -S bitwarden-cli     # command line bitwarden client
sudo pacman --noconfirm -S mousepad          # simple graphical text editor
sudo pacman --noconfirm -S file-roller       # archive manager
sudo pacman --noconfirm -S evince            # pdf viewer
sudo pacman --noconfirm -S xournalpp         # pdf editor
sudo pacman --noconfirm -S libreoffice       # office packages
sudo pacman --noconfirm -S gimp              # image editor
sudo pacman --noconfirm -S gpick             # color picker
sudo pacman --noconfirm -S inkscape          # vector graphics editor
sudo pacman --noconfirm -S fontforge         # fonts editor
sudo pacman --noconfirm -S gparted           # grphical disk management tool
sudo pacman --noconfirm -S vlc               # video player
sudo pacman --noconfirm -S remmina           # remote desktop client
sudo pacman --noconfirm -S shotcut           # video editing tool
sudo pacman --noconfirm -S evolution         # email client
sudo pacman --noconfirm -S redshift          # adjusts the color temperature of your screen
sudo pacman --noconfirm -S obs-studio        # screencasting and streaming app
sudo pacman --noconfirm -S wireshark-qt      # network protocol analyzer
sudo pacman --noconfirm -S spotify-launcher  # spotify client
sudo pacman --noconfirm -S telegram-desktop  # my preffered messenger
sudo pacman --noconfirm -S rclone            # manage or migrate files on cloud storage
sudo pacman --noconfirm -S openvpn           # openvpn client
sudo pacman --noconfirm -S wireguard-tools   # wireguard client
sudo pacman --noconfirm -S arandr            # gui for xrandr

# Step 02: Install package manager for AUR (Arch User Repository)

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Step 03: Software development tools
# General purpose development tools:

sudo pacman --noconfirm -S neovim          # powerful console editor
sudo pacman --noconfirm -S zed             # ultimate graphical editor
sudo pacman --noconfirm -S tree-sitter     # parsing system for programming tools
sudo pacman --noconfirm -S tree-sitter-cli # cli tool tree-sitter parsers
sudo pacman --noconfirm -S stow            # configuration manager
sudo pacman --noconfirm -S sqlite3         # console sqlite client
sudo pacman --noconfirm -S tldr            # collection of simplified man pages
sudo pacman --noconfirm -S jq              # cli json processor
sudo pacman --noconfirm -S tmux            # terminal session multiplexer
sudo pacman --noconfirm -S nmap            # network scanner with advanced features
sudo pacman --noconfirm -S masscan         # high performance network scanner
sudo pacman --noconfirm -S pgcli           # console client for PostgreSQL
sudo pacman --noconfirm -S redis           # console client for Redis
sudo pacman --noconfirm -S apache          # http server + some useful utilities (htpasswd)
sudo pacman --noconfirm -S meld            # git visual diff and merge tool
sudo pacman --noconfirm -S websocat        # command line client for websockets
sudo pacman --noconfirm -S sshpass         # noninteractive ssh password provider
sudo pacman --noconfirm -S git-filter-repo # faster and safer git-filter-branch alternative

# 💡 IMPORTANT NOTE: execute sudo setcap 'cap_net_raw+epi' /usr/bin/masscan to enable the ability to run masscan as non-root user.
# Infrastructure as a Code and DevOps tools:
sudo pacman --noconfirm -S ansible          # infrastructure as a code tool (bare metal)
sudo pacman --noconfirm -S podman           # cli tool for container management
sudo pacman --noconfirm -S podman-compose   # run multi-container applications with podman
sudo pacman --noconfirm -S docker           # cli tool for container management
sudo pacman --noconfirm -S docker-compose   # run multi-container applications with docker
sudo pacman --noconfirm -S kubectl          # cli tool for managing kubernetes clusters
sudo pacman --noconfirm -S helm             # package manager for kubernetes
sudo pacman --noconfirm -S terraform        # infrastructure as a code tool (clouds)

#### configure docker

sudo systemctl enable docker            # enable docker daemon on system start
sudo usermod -a -G docker yst  # to be able to run docker as non-root
newgrp docker                           # login to docker group without restart
# Install Golang and its tools:
sudo pacman --noconfirm -S go
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest
# Install Java and its tools:
sudo pacman --noconfirm -S jdk8-openjdk    # OpenJDK Java  8 development kit
sudo pacman --noconfirm -S jdk11-openjdk   # OpenJDK Java 11 development kit
sudo pacman --noconfirm -S jdk17-openjdk   # OpenJDK Java 17 development kit
sudo pacman --noconfirm -S jdk21-openjdk   # OpenJDK Java 21 development kit
sudo pacman --noconfirm -S jdk-openjdk     # OpenJDK Java 22 development kit
sudo pacman --noconfirm -S maven           # Java project management tool
sudo pacman --noconfirm -S gradle          # Java project management tool
#💡 IMPORTANT NOTE: JVM version can be switched using archlinux-java. List all available JVM versions using archlinux-java status and set one using archlinux-java set VERSION.
# Install Dart and Flutter following instructions from https://docs.flutter.dev/get-started/install/linux

# Install C, C++ and tools for low-level development:

sudo pacman --noconfirm -S gcc         # GNU Compiler Collection, C and C++ frontends
sudo pacman --noconfirm -S gdb         # GNU Debugger
sudo pacman --noconfirm -S clang       # C/C++ frontend compiler for LLVM
sudo pacman --noconfirm -S cmake       # C/C++ project management tool
sudo pacman --noconfirm -S ninja       # Build system with a focus on speed
sudo pacman --noconfirm -S cuda        # NVIDIA GPU programming toolkit
sudo pacman --noconfirm -S nasm        # Asssembler for the x86 CPU architecture
sudo pacman --noconfirm -S boost       # C++ library with general purpose utils and data structures
sudo pacman --noconfirm -S cdrtools    # CD/DVD/BluRay command line recording software
sudo pacman --noconfirm -S qemu-full   # Open source machine emulator and virtualizer
# Install Python and its tools:
sudo pacman --noconfirm -S python          # python itself
sudo pacman --noconfirm -S python-pip      # python package manager
sudo pacman --noconfirm -S python-poetry   # python package manager (better one)
# Install Lua:
sudo pacman --noconfirm -S lua       # Collection of Lua tools
# Install JavaScript and its tools:
sudo pacman --noconfirm -S nodejs    # JavaScript runtime
sudo pacman --noconfirm -S npm       # JavaScript package manager
sudo pacman --noconfirm -S yarn      # JavaScript package manager

# Install Rust and its tools:
sudo pacman --noconfirm -S rust     # Rust compiler and tools for project management
# Install Virtualbox:
sudo pacman --noconfirm -S linux-headers          # Headers for building Linux kernel modules
sudo pacman --noconfirm -S virtualbox-host-dkms   # VirtualBox Host kernel modules sources
sudo pacman --noconfirm -S virtualbox             # Hypervisor for x86 virtualization
# Architecture diagraming tools:
sudo pacman --noconfirm -S plantuml    # Tool for creating UML diagrams

# Install Wine and its utilities:
sudo pacman --noconfirm -S wine         # Compatibility layer for running Windows programs
sudo pacman --noconfirm -S wine-mono    # Wine's replacement for Microsoft's .NET Framework
sudo pacman --noconfirm -S wine-gecko   # Wine's replacement for Microsoft's Internet Explorer
sudo pacman --noconfirm -S winetricks   # Installer for various runtime libraries in Wine
sudo pacman --noconfirm -S zenity       # Display dialog boxes from shell scripts (wine dependency)
# Configure smooth font in Wine applications:
winetricks settings fontsmooth=rgb
# 💡 IMPORTANT NOTE: if you are facing error wine: Read access denied for device L"\\??\\Z:\\", FS volume label and serial are not available, go to ~/.wine/dosdevices, remove z: symbolic link and make it point to your $HOME

# Step 05: Install texlive (LaTeX distribution)
# Download texlive installer:
wget http://mirrors.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
# Unpack texlive installer archive:
mkdir ./texlive
tar -xvf install-tl-unx.tar.gz -C texlive --strip-components=1
# Run texlive install and select nearest CTAN mirror:
cd ./texlive
sudo ./install-tl -select-repository

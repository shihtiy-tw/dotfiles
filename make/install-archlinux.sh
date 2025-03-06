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
sudo
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

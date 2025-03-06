#!/bin/bash

# Reference: https://github.com/silentz/arch-linux-install-guide

echo "Useful Utilities:"

sudo pacman --noconfim -S dbus              # Message bus used by many applications
sudo pacman --noconfim -S intel-ucode       # Microcode update files for Intel CPUs
sudo pacman --noconfim -S fuse2             # Interface for programs to export a filesystem to the Linux kernel
sudo pacman --noconfim -S lshw              # Provides detailed information on the hardware of the machine
sudo pacman --noconfim -S powertop          # A tool to diagnose issues with power consumption and power management
sudo pacman --noconfim -S inxi              # Full featured CLI system information tool
sudo pacman --noconfim -S acpi              # Client for battery, power, and thermal readings
sudo
sudo pacman --noconfim -S base-devel        # Basic tools to build Arch Linux packages
sudo pacman --noconfim -S git               # Distributed version control system
sudo pacman --noconfim -S zip               # Compressor/archiver for creating and modifying zipfiles
sudo pacman --noconfim -S unzip             # For extracting and viewing files in .zip archives
sudo pacman --noconfim -S p7zip             # For extracting and viewing files in .7z archives
sudo pacman --noconfim -S htop              # Interactive CLI process viewer
sudo pacman --noconfim -S tree              # A directory listing program
sudo
sudo pacman --noconfim -S dialog            # A tool to display dialog boxes from shell scripts
sudo pacman --noconfim -S reflector         # Script to retrieve and filter the latest Pacman mirror list
sudo pacman --noconfim -S bash-completion   # Programmable completion for the bash shell
sudo
sudo pacman --noconfim -S iw                # CLI configuration utility for wireless devices
sudo pacman --noconfim -S wpa_supplicant    # A utility providing key negotiation for WPA wireless networks
sudo pacman --noconfim -S tcpdump           # Powerful command-line packet analyzer
sudo pacman --noconfim -S mtr               # Combines the functionality of traceroute and ping into one tool
sudo pacman --noconfim -S net-tools         # Configuration tools for Linux networking
sudo pacman --noconfim -S conntrack-tools   # Userspace tools to interact with the Netfilter tracking system
sudo pacman --noconfim -S ethtool           # Utility for controlling network drivers and hardware
sudo pacman --noconfim -S wget              # Network utility to retrieve files from the Web
sudo pacman --noconfim -S rsync             # File copying tool for remote and local files
sudo pacman --noconfim -S socat             # Multipurpose socket relay
sudo pacman --noconfim -S openbsd-netcat    # Netcat program. OpenBSD variant.
sudo pacman --noconfim -S axel              # Light command line download accelerator
sudo pacman --noconfim -S bind              # I use dig utility for DNS resolution from this package

# Install login session manager
sudo pacman -S ly                            # Session manager
sudo systemctl enable ly


# Install essential system fonts:
sudo pacman --noconfim -S ttf-dejavu ttf-freefont ttf-liberation ttf-droid terminus-font
sudo pacman --noconfim -S noto-fonts noto-fonts-emoji ttf-ubuntu-font-family ttf-roboto ttf-roboto-mono ttf-ibm-plex

# [Optional] Enable sound support on your PC:
sudo pacman -S alsa-utils      # Advanced Linux Sound Architecture - Utilities
sudo pacman -S alsa-plugins    # Additional ALSA plugins


# [Optional] Enable bluetooth support on your PC:
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth

# [Optional] Enable printing support on your PC:
sudo pacman -S cups cups-filters cups-pdf system-config-printer
sudo pacman -S hplip    # for HP devices
sudo systemctl enable cups.service
#[Optional] Improve battary usage with TLP - utility that basically does kernel settings tweaking that improve power consumption. More information about TLP can be found here. More information about TLP-RDW (radio device wizard) can be found here.
sudo pacman -S tlp tlp-rdw
sudo systemctl enable tlp

# [Optional] Run service that will discard unused blocks on mounted filesystems. This is useful for solid-state drives (SSDs) and thinly-provisioned storage. More information on fstrim can be found here.
sudo systemctl enable fstrim.timer

# [Optional] Install GTK themes and icons:
sudo pacman -S arc-gtk-theme adapta-gtk-theme materia-gtk-theme
sudo pacman -S papirus-icon-theme
# [Optional] Choose fastest pacman mirrors (use your own country list):
sudo reflector --country United Kingdom,Germany,Switzerland \
                 --fastest 10 \
                 --threads "$(nproc)" \
                 --save /etc/pacman.d/mirrorlist

# [Optional] Install NetworkManager addons:
sudo pacman -S nm-connection-editor networkmanager-openvpn

# [Optional] Install vulkan drivers:
sudo pacman -S mesa vulkan-intel   # only for systems with Intel graphics
sudo pacman -S nvidia-utils        # only for systems with Nvidia graphics

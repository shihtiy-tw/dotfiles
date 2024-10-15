# Version
RUBY_GEM_VERSION=3.4.8

# update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y \
    ninja-build \
    gettext libtool libtool-bin \
    autoconf automake cmake g++ \
    build-essential \
    python3-dev python3-pip\
    pkg-config unzip

sudo apt install -y \
    make libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

sudo apt-get install ripgrep

# install fcitx5 for input switch
sudo apt install fcitx5

# install cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y

# java
sudo apt install default-jdk -y

# install lua
sudo apt install luarocks

# install Golang
sudo apt install golang -y

# install ruby
sudo apt install ruby -y
sudo apt-get install ruby-dev -y
wget https://rubygems.org/rubygems/rubygems-"$RUBY_GEM_VERSION".tgz
tar xvzf rubygems-"$RUBY_GEM_VERSION".tgz
cd rubygems-"$RUBY_GEM_VERSION"; ruby setup.rb; cd

# npm
# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# export the env now to install npm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 20

node -v
nvm -v

# git-sim
sudo apt install pipx -y
sudo apt update
sudo apt install build-essential python3-dev libcairo2-dev libpango1.0-dev ffmpeg -y
pipx install manim
pipx install git-sim

# git
#
#$ curl https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy -o /usr/local/bin/diff-so-fancy
LATEST_VERSION=$(curl -s https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
sudo curl -L -o /usr/local/bin/diff-so-fancy "https://github.com/so-fancy/diff-so-fancy/releases/download/v${LATEST_VERSION}/diff-so-fancy"
sudo chmod +x /usr/local/bin/diff-so-fancy

sudo apt install git-extras

sudo apt install git-lfs

# precommit
sudo apt install pre-commit -y

# tree
sudo apt install tree

# zsh
sudo apt install zsh powerline fonts-powerline -y

sudo apt install shellcheck -y


# oh-my-zsh
if [ ! -d "$HOME"/.oh-my-zsh ]; then \
  git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME"/.oh-my-zsh; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-completions ]; then \
  git clone https://github.com/zsh-users/zsh-completions "$HOME"/.oh-my-zsh/custom/plugins/zsh-completions; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-vim-mode ]; then \
  git clone https://github.com/softmoth/zsh-vim-mode.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-vim-mode; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/fzf-tab ]; then \
  git clone https://github.com/Aloxaf/fzf-tab "${HOME}/.oh-my-zsh/custom/plugins/fzf-tab"; \
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-system-clipboard ]; then \
  git clone https://github.com/kutsan/zsh-system-clipboard "${HOME}/.oh-my-zsh/custom/plugins/zsh-system-clipboard"
fi
if [ ! -d "$HOME"/.oh-my-zsh/custom/themes/spaceship-prompt ]; then \
  git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"; \
  sed -i 's/^SPACESHIP_CHAR_SYMBOL=.*$/SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="$ "}"/' "$HOME"/.oh-my-zsh/custom/themes/spaceship-prompt/sections/char.zsh
  git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git "$HOME"/.oh-my-zsh/custom/plugins/spaceship-vi-mode
  sed -i 's/^SPACESHIP_VI_MODE_SHOW=.*$/SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW=false}"/' "$HOME"/.oh-my-zsh/custom/themes/spaceship-prompt/sections/vi_mode.zsh
fi

# bash-it
#if [ ! -d ${HOME}/.bash_it ]; then \
  #git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it; \
#fi

#${HOME}/bash_it/install.sh --slient
#mkdir -p ${HOME}/.bash_it/custom/themes

# tmux
sudo apt install tmux -y

# install tpm
# https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# vim
# sudo apt-get install vim -y

# fuse
# to use appimage
apt install libfuse2

# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage /usr/loca/bin/nvim

# fzf
if [ ! -d "$HOMW"/.fzf ]; then\
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf; \
  yes | "$HOME"/.fzf/install; \
fi

# ack
#mkdir -p ${HOME}/.local/share/bin
#curl https://beyondgrep.com/ack-v3.1.2 > ${HOME}/.local/share/bin/ack && chmod 0755 ${HOME}/.local/share/bin/ack

# auto jump
if [ ! -d ./autojump ]; then \
  git clone https://github.com/wting/autojump.git /tmp/autojump; \
  cd /tmp/autojump
  python3 install.py; \
  cd "$HOME"
fi

# yazi file manager
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo install --locked yazi-fm yazi-cli

# python3
sudo ln -s "$(which python3)" /usr/local/bin/python

[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source "$HOME"/.autojump/etc/profile.d/autojump.sh

# Ag
sudo apt install silversearcher-ag -y

# Docker
#
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove "$pkg"; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker

# imagemagick
sudo apt install imagemagick -y

# kernel tool
sudo add-apt-repository ppa:cappelikan/ppa -y
sudo apt update && sudo apt full-upgrade
sudo apt install -y mainline

# gcc-14
sudo add-apt-repository universe
sudo apt install gcc-14

# tig
sudo apt-get install tig -y

# imagemagick
sudo apt-get install imagemagick

# gh
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
sudo apt update -y
sudo apt install gh -y
gh extension install dlvhdr/gh-dash

# terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform


cd "$HOME"

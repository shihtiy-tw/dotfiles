# update and upgrade packages
sudo apt-get update -y
sudo apt upgrade -y

sudo apt-get install -y \
    ninja-build \
    gettext libtool libtool-bin \
    autoconf automake cmake g++ \
    build-essential \
    python3-dev \
    pkg-config unzip

sudo apt-get install -y \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev


sudo apt-get -y install python3-pip -y

# zsh
sudo apt install zsh -y
sudo apt-get install powerline fonts-powerline -y

# oh-my-zsh
if [ ! -d ${HOME}/.oh-my-zsh ]; then \
  git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions ]; then \
  git clone https://github.com/zsh-users/zsh-completions ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/zsh-vim-mode ]; then \
  git clone https://github.com/softmoth/zsh-vim-mode.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-vim-mode; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/fzf-tab ]; then \
  git clone https://github.com/Aloxaf/fzf-tab "${HOME}/.oh-my-zsh/custom/plugins/fzf-tab"; \
fi
if [ ! -d ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt ]; then \
  git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"; \
  sed -i 's/^SPACESHIP_CHAR_SYMBOL=.*$/SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="$ "}"/' ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/sections/char.zsh
  sed -i 's/^SPACESHIP_VI_MODE_SHOW=.*$/SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW=false}"/' ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/sections/vi_mode.zsh
fi

# bash-it
#if [ ! -d ${HOME}/.bash_it ]; then \
  #git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it; \
#fi

#${HOME}/bash_it/install.sh --slient
#mkdir -p ${HOME}/.bash_it/custom/themes

# tmux
sudo apt install tmux -y

# vim
sudo apt-get install vim -y

# node
#curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
#sudo apt-get install nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm i -g bash-language-server
sudo npm install -g markdownlint-cli

# neovim
sudo apt-get install python3-neovim -y
sudo npm install -g neovim
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x /tmp/nvim.appimage
sudo rm -f /usr/bin/nvim
#sudo ln -s ${HOME}/dotfiles/nvim.appimage /usr/bin/nvim
sudo mv /tmp/nvim.appimage /usr/bin/nvim

python3 -m pip uninstall pynvim neovim --user
python3 -m pip install pynvim --user
python3 -m pip install neovim --user

pip install vim-vint

# fzf
if [ ! -d ${HOMW}/.fzf ]; then\
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf; \
  yes | ${HOME}/.fzf/install; \
fi

# ack
#mkdir -p ${HOME}/.local/share/bin
#curl https://beyondgrep.com/ack-v3.1.2 > ${HOME}/.local/share/bin/ack && chmod 0755 ${HOME}/.local/share/bin/ack

# auto jump
if [ ! -d ./autojump ]; then \
  git clone git://github.com/joelthelion/autojump.git /tmp/autojump; \
  cd /tmp/autojump
  python3 install.py; \
fi

# python3
sudo ln -s $(which python3) /usr/local/bin/python

[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh

# Go
wget -q -O - https://git.io/vQhTU | bash

# efm server
go install github.com/mattn/efm-langserver@latest

# Ag
sudo apt-get install silversearcher-ag -y


cd ${HOME}

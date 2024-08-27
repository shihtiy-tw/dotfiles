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

# git
#
#$ curl https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.4/diff-so-fancy -o /usr/local/bin/diff-so-fancy

# zsh
sudo apt install zsh powerline fonts-powerline -y

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
  git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git ${HOME}/.oh-my-zsh/custom/plugins/spaceship-vi-mode
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
# sudo apt-get install vim -y

# fuse
# to use appimage
apt install libfuse2

# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage /usr/loca/bin/nvim

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
  git clone https://github.com/wting/autojump.git /tmp/autojump; \
  cd /tmp/autojump
  python3 install.py; \
  cd ${HOME}
fi

# python3
sudo ln -s $(which python3) /usr/local/bin/python

[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh

# Ag
sudo apt install silversearcher-ag -y

cd ${HOME}

# update and upgrade packages
sudo yum update -y

sudo yum -y groupinstall development
sudo yum install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
sudo yum install -y fuse


# python
# sudo yum -y install python3.x86_64
# sudo yum -y install python3-devel.x86_64

if [ "${HOME}" = "/root" ]; then \
  sudo yum -y install python3*; \
  sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
fi

# zsh
sudo yum install zsh -y

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

#${HOME}/.bash_it/install.sh --slient
#mkdir -p ${HOME}/.bash_it/custom/themes

# tig
sudo yum install ncurses-devel ncurses -y
if [ ! -d ${HOMW}/dotfiles/tig ]; then \
  git clone git://github.com/jonas/tig.git ${HOME}/dotfiles/tig; \
  make -C tig; \
  make -C tig install; \
fi

# ccls
yum provides '*/libncurses.so.5'
sudo yum install ncurses-compat-libs -y
if [ ! -d ${HOME}/dotfiles/ccls ]; then \
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls; ${HOME}/dotfiles/ccls\
  cd ccls; \
    wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz ${HOME}/dotfiles/ccls; \
    tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz; \
    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04; \
    cmake --build Release; \
    sudo ln -sf $PWD/Release/ccls /usr/local/bin/ccls; \
fi

# go
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz

# efm LSP
go get github.com/mattn/efm-langserver

# tmux
sudo yum install tmux -y

# vim
sudo yum install vim -y

# diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod a+x diff-so-fancy
sudo ln -sf ${PWD}/diff-so-fancy /usr/local/bin/diff-so-fancy

# node
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install nodejs -y
sudo npm i -g bash-language-server
sudo npm install -g markdownlint-cli

# iperf
sudo yum install -y iperf3

# hping3
sudo amazon-linux-extras install epel -y
sudo yum install -y hping3

# atop
sudo yum install -y atop

# jq
sudo yum install -y jq

# neovim
sudo yum install -y neovim python3-neovim
sudo npm install -g neovim
pip3 install pynvim --user
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x /tmp/nvim.appimage
sudo rm -f /usr/bin/nvim
#sudo ln -s ${HOME}/dotfiles/nvim.appimage /usr/bin/nvim
sudo mv /tmp/nvim.appimage /usr/bin/nvim

python3 -m pip uninstall pynvim neovim --user
python3 -m pip install pynvim --user
python3 -m pip install neovim --user

pip install vim-vint

if [ ! -d ${HOMW}/.fzf ]; then\
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf; \
  yes | ${HOME}/.fzf/install; \
fi

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
sudo yum install epel-release.noarch the_silver_searcher -y

cd ${HOME}

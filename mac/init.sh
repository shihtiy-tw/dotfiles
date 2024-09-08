#!/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Mac Setup Script

# dotfile

git clone https://github.com/shihtiy-tw/dotfiles.git "${HOME}"/dotfiles

# brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

cd ${HOME}/dotfiles/mac || exit

if [[ $(uname -m) == 'arm64' ]]; then
    echo "Running on Apple Silicon (ARM)"
    # ARM-specific Homebrew packages or settings
    brew bundle --file Brewfile.arm
else
    echo "Running on Intel (x86)"
    # Intel-specific Homebrew packages or settings
    brew bundle --file Brewfile.x86
fi

# Common commands for both architectures


# oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
git clone https://github.com/zsh-users/zsh-completions ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions; \
git clone https://github.com/softmoth/zsh-vim-mode.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-vim-mode; \
git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"; \
git clone https://github.com/Aloxaf/fzf-tab ${HOME}/.oh-my-zsh/custom/plugins/fzf-tab

ln -sf ${HOME}/dotfiles/zsh/spaceship-prompt/spaceship.zsh ${HOME}/.oh-my-zsh/custom/themes/spaceship.zsh-theme
sed -i '' 's/^SPACESHIP_CHAR_SYMBOL=.*$/SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="$ "}"/' ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/sections/char.zsh


## Autojump

git clone git://github.com/joelthelion/autojump.git ${HOME}/dotfiles/autojump; \
cd ${HOME}/dotfiles/autojump/ || exit; \
python3 ${HOME}/dotfiles/autojump/install.py; \


brew install golang
export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
go get github.com/mattn/efm-langserver
$HOME/.config/efm-langserver/config.yaml
mkdir $HOME/.config/efm-langserver
ln -s $HOME/dotfiles/nvim/efm-langserver-config.yaml

mkdir ~/.nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source $HOME/.bashrc
nvm install 11.14.0
nvm use v11.14.0
nvm alias default 11.14.0
npm install -g bash-language-server


pip3 install awscli --upgrade --user

brew cleanup

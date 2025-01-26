#!/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Mac Setup Script

# dotfile

git clone https://github.com/shihtiy-tw/dotfiles.git "$HOME"/dotfiles

# brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo >> /Users/yst/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/yst/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

cd "$HOME"/dotfiles/make/mac || exit

# gitflow
wget -q  https://raw.githubusercontent.com/CJ-Systems/gitflow-cjs/develop/contrib/gitflow-installer.sh && sudo bash gitflow-installer.sh install stable; rm gitflow-installer.sh

# https://github.com/petervanderdoes/gitflow-avh/issues/126#issuecomment-27480324
echo 'FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"' > ~/.gitflow_export

# install from
# brew bundle dump --file=~/dotfiles/make/mac/Brewfile.x86 --force
# brew bundle dump --file=~/dotfiles/make/mac/Brewfile.arm --force

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

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# install cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y

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

## Autojump

git clone git://github.com/joelthelion/autojump.git "$HOME"/dotfiles/autojump; \
cd "$HOME"/dotfiles/autojump/ || exit; \
python3 "$HOME"/dotfiles/autojump/install.py; \

## Rust and Cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y

# pyenv
curl https://pyenv.run | bash

# Ruby
brew install rbenv ruby-build
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile

# for im-select.nvim
# https://github.com/keaising/im-select.nvim?tab=readme-ov-file#12-macos
brew tap laishulu/homebrew
brew install macism


# brew install golang
# export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
# export GOROOT=/usr/local/opt/go/libexec
# export PATH=$PATH:$GOPATH/bin
# export PATH=$PATH:$GOROOT/bin
# go get github.com/mattn/efm-langserver
# $HOME/.config/efm-langserver/config.yaml
# mkdir $HOME/.config/efm-langserver
# ln -s $HOME/dotfiles/nvim/efm-langserver-config.yaml
#
# mkdir ~/.nvm
# wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
# source $HOME/.bashrc
# nvm install 11.14.0
# nvm use v11.14.0
# nvm alias default 11.14.0
# npm install -g bash-language-server


brew cleanup

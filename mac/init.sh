#/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew tap Homebrew/bundle
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
brew install fontforge
brew cask install fontforge

brew cask install iterm2
git clone https://github.com/dracula/iterm.git

brew install git-secrets

brew cask install sublime-text

brew install ctags

brew install awscli
brew tap wallix/awless; brew install awless
pip install aws-shell --user

brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf

brew install jq

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir -p ~/.oh-my-zsh/custom/themes/ieni
ln -s ~/dotfiles/zsh/ieni.zsh-theme ~/.oh-my-zsh/custom/themes/ieni/ieni.zsh-theme

git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

brew install node

brew install golang
export GOPATH=$HOME/go-workspace # don't forget to change your path correctly!
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
go get github.com/mattn/efm-langserver
$HOME/.config/efm-langserver/config.yaml
mkdir $HOME/.config/efm-langserver
ln -s $HOME/dotfiles/nvim/efm-langserver-config.yaml

brew install fzf
$(brew --prefix)/opt/fzf/install

mkdir ~/.nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source $HOME/.bashrc
nvm install 11.14.0
nvm use v11.14.0
nvm alias default 11.14.0
npm install -g bash-language-server


brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

brew install the_silver_searcher
brew install autojump

pip3 install awscli --upgrade --user

brew cleanup

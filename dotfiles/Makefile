# variable
ZSHRCPATH = "${HOME}/.zshrc"
ZSHRCBACKUPPATH = "${HOME}/.zshrc_backup"
BASHRCPATH = "${HOME}/.bashrc"
BASHRCBACKUPPATH = "${HOME}/.bashrc_backup"
TMUXCONFPATH = "${HOME}/.tmux.conf"
TMUXCONFBACKUPPATH = "${HOME}/.tmux.conf_backup"
GITCONFIGPATH = "${HOME}/.gitconfig"
GITCONFIGBACKUPPATH = "${HOME}/.gitconfig_backup"
VIMRCPATH = "${HOME}/.vimrc"
VIMRCBACKUPPATH = "${HOME}/.vimrc_backup"
INITVIMPATH = "${HOME}/.config/nvim/init.vim"
INITVIMBACKUPPATH = "${HOME}/.config/nvim/init.vim_backup"

PHONY: help

help:
	@echo "\n\
	Usages: \n\
		hello: hello\n\
		init: download zsh, tmux and config all dotfiles\n\
		status: show dotfile status\n\
		diff: show dotfile status\n\
		add: show dotfile status\n\
		commit: show dotfile status\n\
		ls: show dotfiles \n\
		rm_env: remove env\n\
	"

hello:
	@echo " \n\
 _   _      _ _        __        __         _     _ \n\
| | | | ___| | | ___   \ \      / /__  _ __| | __| |\n\
| |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _\` |\n\
|  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |\n\
|_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_|\n\
	\n\
	"

install:

	# zsh
	wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
	mkdir zsh && unxz zsh.tar.xz && tar -xvf zsh.tar -C zsh --strip-components 1
	cd zsh
	./configure --prefix=$HOME
	make
	make install

	# update and upgrade packages
	sudo apt-get update -y
	sudo apt upgrade -y

	# zsh
	sudo apt install zsh -y
	sudo apt-get install powerline fonts-powerline -y

	# oh-my-zsh
	git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins

	# tmux
	sudo apt install tmux -y

	# neovim
	sudo apt-get install neovim -y
	sudo apt-get install python3-neovim -y
	sudo apt install build-essential cmake python3-dev -y

	# dotfiles
	git clone git@github.com:stanleyuan/dotfiles.git ${HOME}

	mkdir -p ${HOME}/.config/nvim/
	ln -sf ${HOME}/dotfiles/zshrc ${HOME}/.zshrc
	ln -sf ${HOME}/dotfiles/zsh/ieni.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/ieni.zsh-theme
	ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
	ln -sf ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
	ln -sf ${HOME}/dotfiles/init.vim ${HOME}/.config/nvim/init.vim
	ln -sf ${HOME}/dotfiles/nvim/init.vim ${HOME}/.config/nvim/init.vim

	@echo "\ndone\n"

status:
	/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} status

diff:
	/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} diff

add:
	/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} add

commit:
	/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} commit -v

ls:
	/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} ls-tree --full-tree -r HEAD

remove_env:
	@echo "\n\
 ____                                 ___           _   _____\n\
|  _ \ ___ _ __ ___   _____   _____  |_ _|___ _ __ (_) | ____|_ ____   __\n\
| |_) / _ \ '_ \` _ \ / _ \ \ / / _ \  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
|  _ <  __/ | | | | | (_) \ V /  __/  | |  __/ | | | | | |___| | | \ V /\n\
|_| \_\___|_| |_| |_|\___/ \_/ \___| |___\___|_| |_|_| |_____|_| |_|\_/\n\
\n\
	"


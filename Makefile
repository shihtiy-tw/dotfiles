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
		install: download applications\n\
		init: config all dotfiles\n\
		status: show dotfile status\n\
		diff: show dotfile status\n\
		add: show dotfile status\n\
		commit: show dotfile status\n\
		ls: show dotfiles \n\
		rm_env: remove env\n\
	"

hello:
	#@echo " \n\
 #_   _      _ _        __        __         _     _ \n\
#| | | | ___| | | ___   \ \      / /__  _ __| | __| |\n\
#| |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _\` |\n\
#|  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |\n\
#|_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_|\n\
	#\n\
	#"

install-aws:
	#@echo "\n\
 #___           _        _ _   _____           _\n\
#|_ _|_ __  ___| |_ __ _| | | |_   _|__   ___ | |___ \n\
 #| || '_ \/ __| __/ _` | | |   | |/ _ \ / _ \| / __|\n\
 #| || | | \__ \ || (_| | | |   | | (_) | (_) | \__ \\n\
#|___|_| |_|___/\__\__,_|_|_|   |_|\___/ \___/|_|___/\n\
	#\n\
	#"

	# update and upgrade packages
	sudo yum update -y
	sudo yum upgrade -y
	sudo yum -y groupinstall development

	# python
	# sudo yum -y install python3.x86_64
	# sudo yum -y install python3-devel.x86_64
	sudo yum -y install python3*

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

	if [ ! -d ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt ]; then \
		git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"; \
	fi

	# bash-it
	if [ ! -d ${HOME}/.bash_it ]; then \
		git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it; \
	fi

	${HOME}/.bash_it/install.sh --slient
	mkdir -p ${HOME}/.bash_it/custom/themes

	# tmux
	sudo yum install tmux -y

	# vim
	sudo yum install vim -y

	# node
	sudo yum install -y gcc-c++ make
	curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
	sudo yum install nodejs -y
	sudo npm i -g bash-language-server

	# neovim
	sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	sudo yum install -y neovim python3-neovim

	pip3 install pynvim --user
	sudo yum install build-essential cmake python3-dev -y
	wget https://github.com/neovim/neovim/releases/download/v0.3.8/nvim.appimage
	chmod u+x nvim.appimage
	./nvim.appimage --appimage-extract
	sudo rm /usr/bin/nvim
	#sudo ln -s ${HOME}/dotfiles/nvim.appimage /usr/bin/nvim
	sudo ln -sf ${HOME}/dotfiles/squashfs-root/usr/bin/nvim /usr/bin/nvim
	sudo ln -sf ${HOME}/dotfiles/git/diff-so-fancy.sh /usr/local/bin/diff-so-fancy

	git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
	${HOME}/.fzf/install

	mkdir -p ${HOME}/.local/share/bin
	curl https://beyondgrep.com/ack-v3.1.2 > ${HOME}/.local/share/bin/ack && chmod 0755 ${HOME}/.local/share/bin/ack

	if [ ! -d ./autojump ]; then \
		git clone git://github.com/joelthelion/autojump.git ${HOME}/.autojump; \
		python3 ${HOME}/.autojump/install.py; \
	fi


install-ubuntu:
	#@echo "\n\
 #___           _        _ _   _____           _\n\
#|_ _|_ __  ___| |_ __ _| | | |_   _|__   ___ | |___ \n\
 #| || '_ \/ __| __/ _` | | |   | |/ _ \ / _ \| / __|\n\
 #| || | | \__ \ || (_| | | |   | | (_) | (_) | \__ \\n\
#|___|_| |_|___/\__\__,_|_|_|   |_|\___/ \___/|_|___/\n\
	#\n\
	#"


	# zsh
	#wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
	#mkdir zsh && unxz zsh.tar.xz && tar -xvf zsh.tar -C zsh --strip-components 1
	#cd zsh
	#./configure --prefix=$HOME
	#make
	#make install

	# update and upgrade packages
	sudo apt-get update -y
	sudo apt upgrade -y

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

	if [ ! -d ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt ]; then \
		git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"; \
	fi

	# bash-it
	if [ ! -d ${HOME}/.bash_it ]; then \
		git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it; \
	fi

	${HOME}/bash_it/install.sh --slient
	mkdir -p ${HOME}/.bash_it/custom/themes

	# tmux
	sudo apt install tmux -y

	# vim
	sudo apt-get install vim -y

	# node
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt-get install nodejs
	sudo npm i -g bash-language-server

	# neovim
	sudo apt-get install python3-neovim -y
	nmp install -g neovim
	pip3 install pynvim --user
	sudo apt install build-essential cmake python3-dev -y
	wget https://github.com/neovim/neovim/releases/download/v0.3.8/nvim.appimage
	chmod u+x nvim.appimage
	sudo rm /usr/bin/nvim
	sudo ln -s ${HOME}/dotfiles/nvim.appimage /usr/bin/nvim

	git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
	${HOME}/.fzf/install

	mkdir -p ${HOME}/.local/share/bin
	curl https://beyondgrep.com/ack-v3.1.2 > ${HOME}/.local/share/bin/ack && chmod 0755 ${HOME}/.local/share/bin/ack

	if [ ! -d ./autojump ]; then \
		git clone git://github.com/joelthelion/autojump.git; \
		python3 ${HOME}/.autojump/install.py; \
	fi

init:
	#@echo " \n\
 #___       _ _     ___           _   _____\n\
#|_ _|_ __ (_) |_  |_ _|___ _ __ (_) | ____|_ ____   __\n\
 #| || '_ \| | __|  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
 #| || | | | | |_   | |  __/ | | | | | |___| | | \ V /\n\
#|___|_| |_|_|\__| |___\___|_| |_|_| |_____|_| |_|\_/\n\
 #\n\
	#"


	# dotfiles

	#git clone https://github.com/stanleyuan/dotfiles.git ${HOME}

	mkdir -p ${HOME}/.config/nvim/

	if [ -e ${HOME}/.zshrc ]; then \
		mv ${HOME}/.zshrc ${HOME}/.zshrc.backup; \
	fi
	if [ -e ${HOME}/.bashrc ]; then \
		mv ${HOME}/.bashrc ${HOME}/.bash.backup; \
	fi
	if [ -e ${HOME}/.tmux.conf ]; then \
		mv ${HOME}/.tmux.conf ${HOME}/.tmux.conf.backup; \
	fi
	if [ -e ${HOME}/.gitconfig ]; then \
		mv ${HOME}/.gitconfig ${HOME}/.gitconfig.backup; \
	fi
	if [ -e ${HOME}/.config/nvim/init.vim ]; then \
		mv ${HOME}/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim.backup; \
	fi

	ln -sf ${HOME}/dotfiles/zshrc ${HOME}/.zshrc
	# ln -sf ${HOME}/dotfiles/zsh/ieni.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/ieni.zsh-theme
	#ln -sf ${HOME}/dotfiles/bash/themes/fish ${HOME}/.bash_it/custom/themes/fish
	ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
	ln -sf ${HOME}/dotfiles/bashrc ${HOME}/.bash_profile
	ln -sf ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
	ln -sf ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
	ln -sf ${HOME}/dotfiles/vimrc ${HOME}/.vimrc
	ln -sf ${HOME}/dotfiles/nvim/init.vim ${HOME}/.config/nvim/init.vim
	ln -sf ${HOME}/dotfiles/zsh/antigenrc ${HOME}/.antigenrc
	ln -sf ${HOME}/dotfiles/nvim/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
	ln -sf ${HOME}/dotfiles/zsh/spaceship-prompt/spaceship.zsh ${HOME}/.oh-my-zsh/custom/themes/spaceship.zsh-theme

	# neovim
	#nvim -c "PlugInstall"
	#nvim -c "call coc#util#install()"
	#nvim -c "CocInstall coc-dictionary"
	#nvim -c "CocInstall coc-json coc-css coc-python coc-yaml coc-tabnine"
	#nvim -c "CocInstall coc-python coc-yaml coc-tabnine"

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
	#@echo "\n\
 #____                                 ___           _   _____\n\
#|  _ \ ___ _ __ ___   _____   _____  |_ _|___ _ __ (_) | ____|_ ____   __\n\
#| |_) / _ \ '_ \` _ \ / _ \ \ / / _ \  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
#|  _ <  __/ | | | | | (_) \ V /  __/  | |  __/ | | | | | |___| | | \ V /\n\
#|_| \_\___|_| |_| |_|\___/ \_/ \___| |___\___|_| |_|_| |_____|_| |_|\_/\n\
#\n\
	#"

	if [ -e ${HOME}/.zshrc.backup ]; then \
		rm ${HOME}/.zshrc \
		mv ${HOME}/.zshrc.backup ${HOME}/.zshrc; \
	fi
	if [ -e ${HOME}/.bashrc.backup ]; then \
		rm ${HOME}/.bashrc \
		mv ${HOME}/.bash.backup ${HOME}/.bashrc; \
	fi
	if [ -e ${HOME}/.tmux.conf.backup ]; then \
		rm ${HOME}/.tmux.conf.backup \
		mv ${HOME}/.tmux.conf.backup ${HOME}/.tmux.conf; \
	fi
	if [ -e ${HOME}/.gitconfig.backup ]; then \
		rm ${HOME}/.gitconfig \
		mv ${HOME}/.gitconfig.backup ${HOME}/.gitconfig; \
	fi
	if [ -e ${HOME}/.config/nvim/init.vim.backup ]; then \
		rm ${HOME}/.config/nvim/init.vim \
		mv ${HOME}/.config/nvim/init.vim.backup ${HOME}/.config/nvim/init.vim; \
	fi

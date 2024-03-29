#!make
include ./make/envfile
export $(shell sed 's/=.*//' ./make/envfile)

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

env:
		@echo ${ZSHRCPATH}
		@echo ${ZSHRCPATH}
		@echo ${ZSHRCBACKUPPATH}
		@echo ${BASHRCPATH}
		@echo ${BASHRCBACKUPPATH}
		@echo ${TMUXCONFPATH}
		@echo ${TMUXCONFBACKUPPATH}
		@echo ${GITCONFIGPATH}
		@echo ${GITCONFIGBACKUPPATH}
		@echo ${VIMRCPATH}
		@echo ${VIMRCBACKUPPATH}
		@echo ${INITVIMPATH}
		@echo ${INITVIMBACKUPPATH}

		./make/envtest.sh

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
		@echo "\n\
	 ___           _        _ _   _____           _\n\
	|_ _|_ __  ___| |_ __ _| | | |_   _|__   ___ | |___ \n\
	 | || '_ \/ __| __/ _\` | | |   | |/ _ \ / _ \| / __|\n\
	 | || | | \__ \ || (_| | | |   | | (_) | (_) | \__ \\n\
	|___|_| |_|___/\__\__,_|_|_|   |_|\___/ \___/|_|___/\n\
		\n\
		"

		@./make/install-init.sh

init:
		@echo " \n\
	 ___       _ _     ___           _   _____\n\
	|_ _|_ __ (_) |_  |_ _|___ _ __ (_) | ____|_ ____   __\n\
	 | || '_ \| | __|  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
	 | || | | | | |_   | |  __/ | | | | | |___| | | \ V /\n\
	|___|_| |_|_|\__| |___\___|_| |_|_| |_____|_| |_|\_/\n\
	 \n\
		"

		@./make/init.sh

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

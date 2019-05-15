PHONY: help

help:
	@echo "Usages: \n\
	  hello: hello\n\
	  status: show dotfile status\n\
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

init:
	@echo " \n\
 ___       _ _     ___           _   _____\n\
|_ _|_ __ (_) |_  |_ _|___ _ __ (_) | ____|_ ____   __\n\
 | || '_ \| | __|  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
 | || | | | | |_   | |  __/ | | | | | |___| | | \ V /\n\
|___|_| |_|_|\__| |___\___|_| |_|_| |_____|_| |_|\_/\n\
 \n\
	"

status:
	@/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} status

diff:
	@/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} diff

add:
	@/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} add

commit:
	@/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} commit -v

ls:
	@/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} ls-tree --full-tree -r HEAD

remove:
	@echo "\n\
 ____                                 ___           _   _____\n\
|  _ \ ___ _ __ ___   _____   _____  |_ _|___ _ __ (_) | ____|_ ____   __\n\
| |_) / _ \ '_ \` _ \ / _ \ \ / / _ \  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
|  _ <  __/ | | | | | (_) \ V /  __/  | |  __/ | | | | | |___| | | \ V /\n\
|_| \_\___|_| |_| |_|\___/ \_/ \___| |___\___|_| |_|_| |_____|_| |_|\_/\n\
\n\
	"


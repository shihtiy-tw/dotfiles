#!make
include ./make/envfile
export $(shell sed 's/=.*//' ./make/envfile)

# ascii: 3D-ASCII

# Define color codes
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
RESET=\033[0m

.PHONY: help
.PHONY: test
.PHONY: test-install
.PHONY: test-symlinks
.PHONY: clean
.PHONY: all
.PHONY: default
.PHONY: remove_env
.PHONY: remove_env-dry-run
.PHONY: test-container
.PHONY: test-container-full

default: help

help:
	@printf '%b\n' " $(CYAN)Usage: make [target]$(RESET) "
		@printf '%b\n' " $(GREEN)Targets:$(RESET) "
		@printf '%b\n' "  $(YELLOW)hello$(RESET):            hello"
		@printf '%b\n' "  $(YELLOW)install$(RESET):          download applications"
		@printf '%b\n' "  $(YELLOW)init$(RESET):             config all dotfiles"
		@printf '%b\n' "  $(YELLOW)test$(RESET):             run all verification tests"
		@printf '%b\n' "  $(YELLOW)test-install$(RESET):     verify tool installations"
		@printf '%b\n' "  $(YELLOW)test-symlinks$(RESET):    verify dotfile symlinks"
		@printf '%b\n' "  $(YELLOW)test-fix$(RESET):         verify and fix broken symlinks"
		@printf '%b\n' "  $(YELLOW)status$(RESET):           show dotfile status"
		@printf '%b\n' "  $(YELLOW)dark$(RESET):             configure system for dark theme"
		@printf '%b\n' "  $(YELLOW)light$(RESET):            configure system for light theme"
		@printf '%b\n' "  $(YELLOW)diff$(RESET):             show dotfile diff"
		@printf '%b\n' "  $(YELLOW)add$(RESET):              add changes to git"
		@printf '%b\n' "  $(YELLOW)commit$(RESET):           commit changes"
		@printf '%b\n' "  $(YELLOW)ls$(RESET):               show dotfiles"
		@printf '%b\n' "  $(YELLOW)remove_env$(RESET):       unlink dotfiles and restore backups"
		@printf '%b\n' "  $(YELLOW)test-container$(RESET):   run installers in throwaway containers"

# PHONY: help

# help:
# 	@echo "\n\
# 	Usages: \n\
# 		hello: hello\n\
# 		install: download applications\n\
# 		init: config all dotfiles\n\
# 		status: show dotfile status\n\
# 		diff: show dotfile status\n\
# 		add: show dotfile status\n\
# 		commit: show dotfile status\n\
# 		ls: show dotfiles \n\
# 		rm_env: remove env\n\
# 	"

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
	@printf '%b\n' " \n\
 _   _      _ _        __        __         _     _\n\
| | | | ___| | | ___   \\ \\      / /__  _ __| | __| |\n\
| |_| |/ _ \\ | |/ _ \\   \\ \\ /\\ / / _ \\| '__| |/ _\` |\n\
|  _  |  __/ | | (_) |   \\ V  V / (_) | |  | | (_| |\n\
|_| |_|\\___|_|_|\\___/     \\_/\\_/ \\___/|_|  |_|\\__,_|"


install:
		@printf '%b\n' "\n\
	 ___           _        _ _   _____           _\n\
	|_ _|_ __  ___| |_ __ _| | | |_   _|__   ___ | |___ \n\
	 | || '_ \/ __| __/ _\` | | |   | |/ _ \ / _ \| / __|\n\
	 | || | | \__ \ || (_| | | |   | | (_) | (_) | \__ \\n\
	|___|_| |_|___/\__\__,_|_|_|   |_|\___/ \___/|_|___/\n\
		\n\
		"

		@./make/install-init.sh

dark:
	@printf '%b\n' "$(PURPLE) ____             _     __        __         _     _   \n\
|  _ \\  __ _ _ __| | __ \\ \\      / /__  _ __| | __| | \n\
| | | |/ _\` | '__| |/ /  \\ \\ /\\ / / _ \\| '__| |/ _\` | \n\
| |_| | (_| | |  |   <    \\ V  V / (_) | |  | | (_| | \n\
|____/ \\__,_|_|  |_|\\_\\    \\_/\\_/ \\___/|_|  |_|\\__,_| \n $(RESET)"
	@./make/color-theme.sh dark

light:
	@printf '%b\n' "$(YELLOW) \n\
  _     _       _     _    __        __         _     _ \n\
 | |   (_) __ _| |__ | |_  \ \      / /__  _ __| | __| | \n\
 | |   | |/ _\` | '_ \| __|  \ \ /\ / / _ \| '__| |/ _\` | \n\
 | |___| | (_| | | | | |_    \ V  V / (_) | |  | | (_| | \n\
 |_____|_|\__, |_| |_|\__|    \_/\_/ \___/|_|  |_|\__,_| \n\
          |___/ $(RESET)"

	@./make/color-theme.sh light

init:
		@printf '%b\n' " \n\
	 ___       _ _     ___           _   _____\n\
	|_ _|_ __ (_) |_  |_ _|___ _ __ (_) | ____|_ ____   __\n\
	 | || '_ \| | __|  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
	 | || | | | | |_   | |  __/ | | | | | |___| | | \ V /\n\
	|___|_| |_|_|\__| |___\___|_| |_|_| |_____|_| |_|\_/\n\
	 \n\
		"

		@./make/init.sh

status:
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} status

diff:
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} diff

add:
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} add

commit:
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} commit -v

ls:
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} ls-tree --full-tree -r HEAD

remove_env:
	#@echo "\n\
 #____                                 ___           _   _____\n\
#|  _ \ ___ _ __ ___   _____   _____  |_ _|___ _ __ (_) | ____|_ ____   __\n\
#| |_) / _ \ '_ \` _ \ / _ \ \ / / _ \  | |/ _ \ '_ \| | |  _| | '_ \ \ / /\n\
#|  _ <  __/ | | | | | (_) \ V /  __/  | |  __/ | | | | | |___| | | \ V /\n\
#|_| \_\___|_| |_| |_|\___/ \_/ \___| |___\___|_| |_|_| |_____|_| |_|\_/\n\
#\n\
	#"

	@./make/remove-env.sh

remove_env-dry-run:
	@./make/remove-env.sh --dry-run

################################################################################
# TEST TARGETS
################################################################################

test:
	@printf '%b\n' " $(CYAN)Running all verification tests...$(RESET)"
	@./make/test.sh

test-install:
	@printf '%b\n' " $(CYAN)Running installation verification tests...$(RESET)"
	@./make/test-install.sh

test-symlinks:
	@printf '%b\n' " $(CYAN)Running symlink verification tests...$(RESET)"
	@./make/test-symlinks.sh

test-fix:
	@printf '%b\n' " $(CYAN)Running symlink verification and fixing broken links...$(RESET)"
	@./make/test-symlinks.sh --fix

test-verbose:
	@printf '%b\n' " $(CYAN)Running all tests with verbose output...$(RESET)"
	@./make/test.sh --verbose

# Run the installers inside throwaway containers. See make/test/README.md.
# NEVER run the installers directly on your own machine.
test-container:
	@printf '%b\n' " $(CYAN)Running fast container tests (all distros)...$(RESET)"
	@./make/test/run.sh --phase fast

test-container-full:
	@printf '%b\n' " $(CYAN)Running full container installs (this takes a while)...$(RESET)"
	@./make/test/run.sh --phase full

# TODO: add aws and kubernetes script

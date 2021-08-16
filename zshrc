# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
export DOTFILE="${HOME}/dotfiles"


#source $DOTFILE/zsh/antigen.zsh
# Load Antigen configurations
#antigen init $HOME/.antigenrc
#source $HOME/.antigenrc

source $HOME/dotfiles/zsh/omzsh.zsh

# user config
source $HOME/dotfiles/zsh/config.zsh

# alias
source $HOME/dotfiles/zsh/alias.zsh

#source /etc/zsh_command_not_found
#source $HOME/.local/bin/aws_bash_completer
[ -f ${HOME}/.fzf.zsh ] && source ${HOME}/.fzf.zsh

# completions
source $HOME/dotfiles/zsh/completion.zsh

# function
source $HOME/dotfiles/zsh/function.zsh

# ENV VAR
source $HOME/dotfiles/zsh/env.zsh

# color for man pages
source $HOME/dotfiles/zsh/man.zsh

if [ -f ${HOME}/.autojump/share/autojump/autojump.zsh ]; then
	. ${HOME}/.autojump/share/autojump/autojump.zsh
fi

[[ -s /home/shihtiy/.autojump/etc/profile.d/autojump.sh ]] && source /home/shihtiy/.autojump/etc/profile.d/autojump.sh

fpath=(${HOME}/.zsh.d/ $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

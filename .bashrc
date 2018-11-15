# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f /home/ieni/.autojump/share/autojump/autojump.bash ]; then
	. /home/ieni/.autojump/share/autojump/autojump.bash
fi

# mkdir + cd
function mkdircd() {
	command mkdir $1 && cd $1
}

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

stty -ixon #disable ctrl-s
#Alias
alias cp="rsync -ah --progress"
alias open="xdg-open"
alias pingtest="ping 8.8.8.8"
alias c='clear'
alias weka='java -jar /home/ieni/weka-3-8-1/weka.jar'
alias python='python3'
alias pip='pip3'
alias bkliton='echo 1 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
alias bklitoff='echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias myip="ifconfig wlp3s0 | grep -m 1 inet | sed 's/^.*inet addr://g' | sed 's/Bcast.*//g'"
export MYIP=$(myip)
alias notes='sudo updatedb; locate -r ~/".*notes_.*\.md"'
alias def='definition'


export GOOGLE_APPLICATION_CREDENTIALS='/home/ieni/Documents/NTUT/patrick/Natural_Language/Natural_Language_API-a56f9766faee.json'

#export PATH=/usr/local/cuda-8.0/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1
export PATH=${PATH}:/usr/local/cuda-9.0/bin
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64
export TF_CPP_MIN_LOG_LEVEL=2
export VISUAL=vim
export EDITOR="$VISUAL"
export PYTHONPATH=$PATH
#export PYTHONPATH=/usr/local/lib/python3.5/dist-packages:$PYTHONPATH
#export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.5/dist-packages
export ANDROID_HOME='/home/ieni/Android/Sdk'
export CATALINA_HOME='/opt/tomcat'
export PATH=${PATH}:/home/ieni/Documents/NTUT/Learning_Project/idea-IU-182.4892.20/bin

# JAVA_HOME="/usr/lib/jvm/java-8-oracle"
# GOOGLE_APPLICATION_CREDENTIALS='/home/ieni/Documents/NTUT/patrick/Natural_Language/Natural_Language_API-a56f9766faee.json'
# PATH=$PATH:$JAVA_HOME/bin
# PATH=$PATH:$JAVA_HOME/bin
# PATH=$PATH:$SPARK_HOME/bin
# PATH=$PATH:$SPARK_HOME/sbin
# PATH=$PATH:/usr/local/cuda-8.0/bin
# PATH=/usr/local/cuda-8.0/bin:$PATH
# LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1
# TF_CPP_MIN_LOG_LEVEL=2
# VISUAL=vim
# EDITOR="$VISUAL"
# set -gx PATH /usr/local/cuda-8.0/bin $PATH
# set -Ux LD_LIBRARY_PATH /usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1
# set -Ux TF_CPP_MIN_LOG_LEVEL 2

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.11
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# added by Anaconda3 installer
export PATH="/home/ieni/anaconda3/bin:$PATH"

# Path to the bash it configuration
export BASH_IT="/home/ieni/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='clean'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

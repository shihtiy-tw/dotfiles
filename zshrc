# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="af-magic"
#ZSH_THEME="fishy"
ZSH_THEME="ieni"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ${HOME}/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ${HOME}/.oh-my-zsh/plugins/*
# Custom plugins may be added to ${HOME}/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  #django
  aws
  colorize
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
  #auto-color-ls
  #copyzshell
  #fast-syntax-highlighting
  #fzf-git
  #hacker-quotes
  #kube-ps1
  #ls
  #web-search
  autojump
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 #if [[ -n $SSH_CONNECTION ]]; then
   #export EDITOR='nvim'
   #export VISUAL='nvim'
 #else
   #export EDITOR='vim'
   #export VISUAL='vim'
 #fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="${HOME}/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ${HOME}/.zshrc"
# alias ohmyzsh="mate ${HOME}/.oh-my-zsh"
#
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#
if [ $(uname -s) = "Darwin" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh  ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
  nvm alias default 11.14.0
  nvm use v11.14.0
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cp="rsync -ah --progress"
alias open="xdg-open"
alias pingtest="ping 8.8.8.8"
alias c='clear'
alias weka='java -jar ${HOME}/weka-3-8-1/weka.jar'
alias python='python3.6'
alias pip='pip3'
alias bkliton='echo 1 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
alias bklitoff='echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias notes='sudo updatedb; locate -r ${HOME}/".*notes_.*\.md"'
alias def='definition'
alias weather='curl wttr.in'
alias tldr='tldr -t ocean'
alias vim="nvim"
alias sudo='sudo '

if [ $(uname -s) != "Darwin" ]; then
  alias rm="trash"
  alias say="spd-say"
  alias myip="ifconfig wlp3s0 | grep -m 1 inet | sed 's/^.*inet addr://g' | sed 's/Bcast.*//g'"
  export MYIP=$(myip)
fi


#source /etc/zsh_command_not_found
#source $HOME/.local/bin/aws_bash_completer
[ -f ${HOME}/.fzf.zsh ] && source ${HOME}/.fzf.zsh

# awless
if [ -f "$(which awless)" ]; then source <(awless completion zsh); fi

# kubectl
if [ -f "$(which kubectl)" ]; then source <(kubectl completion zsh); fi

# minikube
if [ -f "$(which minikube)" ]; then source <(minikube completion zsh); fi

# helm
if [ -f "$(which helm)" ]; then source <(helm completion zsh); fi

#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# explain.sh begins
explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# ENV VAR
export LC_ALL=en_US.UTF-8
export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.local/share/bin
export PATH=${PATH}:${HOME}/.local/share/
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64
export TF_CPP_MIN_LOG_LEVEL=2
export VISUAL=nvim
export MYVIMRC="${HOME}/.vimrc"
export EDITOR="$VISUAL"
export GOROOT='/usr/local/go'
export GOPATH="${HOME}/go"
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export ANDROID_HOME='${HOME}/Android/Sdk'
export CATALINA_HOME='/opt/tomcat'
export PATH=${PATH}:/usr/local/cuda-9.0/bin
export PATH=${PATH}:${HOME}/.cargo/bin
export PATH=${PATH}:${HOME}/Tools/codimd-cli/bin
export PATH=${PATH}:${HOME}/arduino-1.8.8
export PATH=${PATH}:${JAVA_HOME}
export GEM_HOME="~/.gem/ruby/2.5.0/"
export PATH="$PATH:$GEM_HOME"
export PATH="$PATH:${HOME}/Tools/Sonar/sonar-scanner-4.0.0.1744-linux/bin"
export WORKON_HOME=$HOME/.virtualenvs
export CODIMD_SERVER='127.0.0.1:3000'
# added by Anaconda3 installer
export PATH="${HOME}/anaconda3/bin:$PATH"

#export PATH=${PATH}:${HOME}/Documents/NTUT/Learning_Project/idea-IU-182.4892.20/bin
#export PATH=${PATH}:${HOME}/Documents/NTUT/Learning_Project/DataGrip-2018.3/bin
#export PYTHONPATH=$PATH
#export PYTHONPATH="/usr/local/lib/python3.5/dist-packages"
#export PYTHONPATH=/usr/local/lib/python3.6/dist-packages:$PYTHONPATH
#export PYTHONPATH=/usr/local/lib/python3.7/dist-packages:$PYTHONPATH
#export RUBY_HOME=~/.ruby
#export PATH="$PATH:~/.ruby/bin"
#export GOOGLE_APPLICATION_CREDENTIALS='${HOME}/Documents/NTUT/patrick/Natural_Language/Natural_Language_API-a56f9766faee.json'
#export PATH=/usr/local/cuda-8.0/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1

# color for man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

# convenience
if [ -d $HOME/Library/Python/3.7/bin ]; then
    export PATH=$HOME/Library/Python/3.7/bin:$PATH
fi

if [ -f ${HOME}/.autojump/share/autojump/autojump.zsh ]; then
	. ${HOME}/.autojump/share/autojump/autojump.zsh
fi

# mkdir + cd
function mkdircd() {
	command mkdir $1 && cd $1
}

# curl cheat.sh
function cheat() {
  command curl cheat.sh/$1
}

# swagger-edit
function swagger-edit() {
	docker run -it --rm --volume="$(pwd)":/swagger -p 8080:8080 zixia/swagger-edit "$@"
}

# Swagger ui preview
# https://github.com/xavierchow/vim-swagger-preview
function swagger_yaml2json() {
  TMP_DIR="/tmp/vim-swagger-preview/"
  LOG=$TMP_DIR"validate.log"
  docker run --rm -v $(pwd):/docs rovecom/swagger-tools swagger-tools validate /docs/"$1" > $LOG 2>&1
  if [[ -s "$LOG" ]]; then
    # File exists and has a size greater than zero
    return 1
  else
    docker run -v "$(pwd)":/docs -v $TMP_DIR:/out swaggerapi/swagger-codegen-cli generate -i /docs/"$1" -l swagger -o /out
    return 0
  fi
}
function swagger_ui_start() {
    CONTAINER_NAME=${1:-swagger-ui-preview}
    TMP_DIR="/tmp/vim-swagger-preview/"
    # VOLUME=$(echo $(pwd) | tr "/" "_")
    if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "exited, cleaning"
            # cleanup
            # echo removing:
            docker rm $CONTAINER_NAME
        fi
        # run the container
        docker run --name $CONTAINER_NAME -d -p 8017:8080 -e SWAGGER_JSON=/docs/swagger.json -v $TMP_DIR:/docs swaggerapi/swagger-ui
    elif [ "$(docker ps -aq -f status=running -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "is already running"
    fi
}
function swagger_preview() {
    TMP_DIR="/tmp/vim-swagger-preview/"
    LOG=$TMP_DIR"validate.log"
    SOURCE=${1:-swagger.yaml}
    $(swagger_yaml2json $SOURCE)
    YAML2JSON_RETURN_CODE=$?
    if [ "$YAML2JSON_RETURN_CODE" -eq "0" ]; then
      swagger_ui_start
    else
      cat $LOG
      echo "Converting to json failed!"
    fi
}

fpath=(${HOME}/.zsh.d/ $fpath)



test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

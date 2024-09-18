# General
export LC_ALL=en_US.UTF-8
export VISUAL=vi
export EDITOR="$VISUAL"
export MYVIMRC="${HOME}/.vimrc"

# Color
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'

# OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*)    OS=Cygwin;;
    MINGW*)     OS=MinGw;;
    *)          OS="UNKNOWN:${unameOut}"
esac
export OS

# Execute Path
export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.local/share/bin
export PATH=${PATH}:${HOME}/.local/share/

# Python
#export PATH=${PATH}:${HOME}/Library/Python/3.9/bin
export PYTHONPATH=$(which python2)
export PYTHON3PATH=$(which python3)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

#eval "$(pyenv virtualenv-init -)"

# convenience
if [ -d $HOME/Library/Python/3.9/bin ]; then
    export PATH=$HOME/Library/Python/3.9/bin:$PATH
fi

# export PYTHON3_SITE="/usr/local/lib/python3.9/site-packages"
# export PYTHON2_SITE="/Library/Python/2.7/site-packages"
# export PYTHON3PATH=$(which python3)
# export PYTHON3PATH=
# export PYTHONPATH=$(which python3)
# export PYTHONPATH="${PYTHON3_SITE}:${PYTHON2_SITE}:$PYTHONPATH"

# Golang
export GOROOT=${HOME}/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=${HOME}/go
export PATH=$GOPATH/bin:$PATH
#export GOROOT='/usr/local/go'
#export GOPATH="${HOME}/go"

# Android
# export ANDROID_HOME='${HOME}/Android/Sdk'

# Arduino
export PATH=${PATH}:${HOME}/arduino-1.8.8

# JAVA
export PATH=${PATH}:${JAVA_HOME}

# Ruby
export GEM_HOME="~/.gem/ruby/2.5.0/"
export PATH="$PATH:$GEM_HOME"
# export RUBY_HOME=~/.ruby
# export PATH="$PATH:~/.ruby/bin"

# Tensorflow
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=${PATH}:/usr/local/cuda-9.0/bin

# Anaconda3 installer
# export PATH="${HOME}/anaconda3/bin:$PATH"

# node
export NODEPATH="$(which node)"

# rust
export PATH=${PATH}:$HOME/.cargo/env

# kubectl
# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Discard
#export GOOGLE_APPLICATION_CREDENTIALS='${HOME}/Documents/NTUT/patrick/Natural_Language/Natural_Language_API-a56f9766faee.json'
#export PATH=/usr/local/cuda-8.0/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1
#export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64
#export CATALINA_HOME='/opt/tomcat'
#export PATH=${PATH}:${HOME}/.cargo/bin
#export PATH=${PATH}:${HOME}/Tools/codimd-cli/bin
#export PATH="$PATH:${HOME}/Tools/Sonar/sonar-scanner-4.0.0.1744-linux/bin"
#export WORKON_HOME=$HOME/.virtualenvs
#export CODIMD_SERVER='127.0.0.1:3000'

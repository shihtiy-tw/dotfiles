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
export NODEPATH="$(which node)"

# convenience
if [ -d $HOME/Library/Python/3.7/bin ]; then
    export PATH=$HOME/Library/Python/3.7/bin:$PATH
fi


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


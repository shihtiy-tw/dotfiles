export LC_ALL=en_US.UTF-8
export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.local/share/bin
export PATH=${PATH}:${HOME}/.local/share/
if [ -d "/usr/local/cuda-9.0/lib64" ]; then
    export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64
fi
export TF_CPP_MIN_LOG_LEVEL=2
export VISUAL=nvim
export MYVIMRC="${HOME}/.vimrc"
export EDITOR="$VISUAL"

# Go setup with platform-specific paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    export GOROOT='/usr/local/opt/go/libexec'
else
    export GOROOT='/usr/local/go'
fi
export GOPATH="${HOME}/go"
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export ANDROID_HOME='${HOME}/Android/Sdk'
export CATALINA_HOME='/opt/tomcat'

# Add CUDA to PATH if it exists
if [ -d "/usr/local/cuda-9.0/bin" ]; then
    export PATH=${PATH}:/usr/local/cuda-9.0/bin
fi

export PATH=${PATH}:${HOME}/.cargo/bin

# Add codimd-cli to PATH if it exists
if [ -d "${HOME}/Tools/codimd-cli/bin" ]; then
    export PATH=${PATH}:${HOME}/Tools/codimd-cli/bin
fi

# Add Arduino to PATH if it exists
if [ -d "${HOME}/arduino-1.8.8" ]; then
    export PATH=${PATH}:${HOME}/arduino-1.8.8
fi
export PATH=${PATH}:${JAVA_HOME}
export GEM_HOME="~/.gem/ruby/2.5.0/"
export PATH="$PATH:$GEM_HOME"
export PATH="$PATH:${HOME}/Tools/Sonar/sonar-scanner-4.0.0.1744-linux/bin"
export WORKON_HOME=$HOME/.virtualenvs
export CODIMD_SERVER='127.0.0.1:3000'
export GEM_HOME=~/.ruby
export PATH="$PATH:~/.ruby/bin"
export PYTHON3PATH=$(which python3)

# macOS-specific Python library paths
if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$HOME/Library/Python/3.7/bin" ]; then
    export PATH=$HOME/Library/Python/3.7/bin:$PATH
fi

# added by Anaconda3 installer
export PATH="${HOME}/anaconda3/bin:$PATH"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


#export GOOGLE_APPLICATION_CREDENTIALS='${HOME}/Documents/NTUT/patrick/Natural_Language/Natural_Language_API-a56f9766faee.json'
#export PATH=/usr/local/cuda-8.0/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH1
#export PATH="$PATH:~/.ruby/bin"
#export RUBY_HOME=~/.ruby
#export PATH=${PATH}:${HOME}/Documents/NTUT/Learning_Project/idea-IU-182.4892.20/bin
#export PATH=${PATH}:${HOME}/Documents/NTUT/Learning_Project/DataGrip-2018.3/bin
#export PYTHONPATH=$PATH
#export PYTHONPATH="/usr/local/lib/python3.5/dist-packages"
#export PYTHONPATH=/usr/local/lib/python3.6/dist-packages:$PYTHONPATH
#export PYTHONPATH=/usr/local/lib/python3.7/dist-packages:$PYTHONPATH

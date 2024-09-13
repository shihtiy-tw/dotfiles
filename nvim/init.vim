" _____            _   _         __     ___
"|  ___|__  _ __  | \ | | ___  __\ \   / (_)_ __ ___
"| |_ / _ \| '__| |  \| |/ _ \/ _ \ \ / /| | '_ ` _ \
"|  _| (_) | |    | |\  |  __/ (_) \ V / | | | | | | |
"|_|  \___/|_|    |_| \_|\___|\___/ \_/  |_|_| |_| |_|
"

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
let g:python_host_prog=$PYTHONPATH
let g:python3_host_prog=$PYTHON3PATH

source $HOME/dotfiles/nvim/vimscript/plugins.vimrc
source $HOME/dotfiles/nvim/vimscript/plugin_config.vimrc
source $HOME/dotfiles/nvim/vimscript/general.vimrc
source $HOME/dotfiles/vim/vimrc
source $HOME/dotfiles/nvim/vimscript/keys.vimrc

" _____            _   _         __     ___
"|  ___|__  _ __  | \ | | ___  __\ \   / (_)_ __ ___
"| |_ / _ \| '__| |  \| |/ _ \/ _ \ \ / /| | '_ ` _ \
"|  _| (_) | |    | |\  |  __/ (_) \ V / | | | | | | |
"|_|  \___/|_|    |_| \_|\___|\___/ \_/  |_|_| |_| |_|
"

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
let g:python_host_prog=$(which python)
let g:python3_host_prog=$(which python3)

source $HOME/dotfiles/nvim/plugins.vimrc
source $HOME/dotfiles/nvim/plugin_config.vimrc
source $HOME/dotfiles/nvim/general.vimrc
source $HOME/dotfiles/vimrc
source $HOME/dotfiles/nvim/keys.vimrc

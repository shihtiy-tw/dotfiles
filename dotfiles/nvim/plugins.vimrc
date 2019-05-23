" ____  _    _   _  ____ ___ _   _ ____
"|  _ \| |  | | | |/ ___|_ _| \ | / ___|
"| |_) | |  | | | | |  _ | ||  \| \___ \
"|  __/| |__| |_| | |_| || || |\  |___) |
"|_|   |_____\___/ \____|___|_| \_|____/
"

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

set nocompatible " Be iMproved
call plug#begin('~/.vim/plugged')

Plug 'sakhnik/nvim-gdb', {'do': ':UpdateRemotePlugins'}
Plug 'SkyLeach/pudb.vim', {'do': ':UpdateRemotePlugins'}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"Plug 'Shougo/neocomplete'
"Plug 'neomake/neomake'


let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

call plug#end()
filetype plugin indent on

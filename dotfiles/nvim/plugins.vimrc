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
call plug#begin('~/.local/share/nvim/plugged')

Plug 'SkyLeach/pudb.vim'
Plug 'numirias/semshi'
Plug 'Shougo/deoplete.nvim'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

"Plug 'Shougo/neocomplete'
"Plug 'neomake/neomake'


let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

" end at vimrc
"call plug#end()

filetype plugin indent on

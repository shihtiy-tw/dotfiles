"       _                       _
"__   _(_)_ __ ___        _ __ | |_   _  __ _
"\ \ / / | '_ ` _ \ _____| '_ \| | | | |/ _` |
" \ V /| | | | | | |_____| |_) | | |_| | (_| |
"  \_/ |_|_| |_| |_|     | .__/|_|\__,_|\__, |
"                        |_|            |___/

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

set nocompatible " Be iMproved
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

"Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"
" Vim theme
Plug 'tomasr/molokai'
Plug 'miyakogi/seiya.vim'
Plug 'crusoexia/vim-monokai'
Plug 'altercation/vim-colors-solarized'

" Make Vim Powerful
Plug 'vim-scripts/Auto-Pairs'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'triglav/vim-visual-increment'
Plug 'vim-scripts/Buffergator'
Plug 'vim-scripts/matchit.zip'
Plug 'xavierchow/vim-swagger-preview'
Plug '~/Tool_from_git/fzf/bin/fzf'
Plug '~/Tool_from_git/fzf/bin/fzf-tmux'
Plug 'junegunn/fzf.vim'
Plug 'wannesm/wmgraphviz.vim'
Plug 'lilydjwg/colorizer'
Plug 'luochen1990/rainbow'
Plug 'inside/vim-search-pulse'
"Plug 'easymotion/vim-easymotion'

Plug 'mhinz/vim-grepper'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
"Plug 'vimwiki/vimwiki'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'shime/vim-livedown'
Plug 'dhruvasagar/vim-table-mode'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"Plug 'dbeniamine/cheat.sh-vim'

Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'Chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', {
            \ 'do': 'npm install',
            \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }



" Syntax
"Plug 'vim-scripts/Conque-GDB'
Plug 'rhysd/vim-grammarous'
Plug 'Valloric/YouCompleteMe',{
            \ 'do': 'python3 install.py --go-completer --ts-completer --java-completer --clang-completer',
            \ 'for': ['javascript', 'c', 'cpp', 'python', 'go']}
Plug 'vim-syntastic/syntastic'

Plug 'chr4/nginx.vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'stanangeloff/php.vim'
"Plug 'hdima/python-syntax'
Plug 'keith/swift.vim'
Plug 'davidhalter/jedi-vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'PProvost/vim-ps1' "ps1
"Plug 'Rip-Rip/clang_complete'
Plug 'wookiehangover/jshint.vim'
Plug 'stevearc/vim-arduino'
Plug 'junegunn/gv.vim'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'

" Command Tool
Plug 'mileszs/ack.vim'

" Misc
Plug 'mattn/webapi-vim' " dependency for gist-vim
Plug 'mattn/gist-vim'
Plug 'editorconfig/editorconfig-vim'

" bash-support
" https://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin

" only load these web front-end related plugins when we need them
if filereadable(expand('~/.frontend.vimenv'))
    " syntax
    Plug 'othree/html5.vim'
    Plug 'alvan/vim-closetag' "html tags
    Plug 'cakebaker/scss-syntax.vim'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'isRuslan/vim-es6'
    Plug 'pangloss/vim-javascript'
    Plug 'othree/yajs.vim'
    Plug 'posva/vim-vue'
    Plug 'slim-template/vim-slim'
    Plug 'digitaltoad/vim-pug'

    " other
    Plug 'mattn/emmet-vim'

endif


let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

call plug#end()
filetype plugin indent on



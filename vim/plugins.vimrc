"__     _____ __  __   ____  _    _   _  ____
"\ \   / /_ _|  \/  | |  _ \| |  | | | |/ ___|
" \ \ / / | || |\/| | | |_) | |  | | | | |  _
"  \ V /  | || |  | | |  __/| |__| |_| | |_| |
"   \_/  |___|_|  |_| |_|   |_____\___/ \____|
"

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

set nocompatible " Be iMproved

if !has('nvim')
  call plug#begin('~/.vim/plugged')
endif

"Plug 'Shougo/vimproc.vim', {'do' : 'make'}

"
"\ \     /_ _|  \  | __ __| |   | ____|  \  | ____|
" \ \   /   |  |\/ |    |   |   | __|   |\/ | __|
"  \ \ /    |  |   |    |   ___ | |     |   | |
"   \_/   ___|_|  _|   _|  _|  _|_____|_|  _|_____|
"
Plug 'tomasr/molokai'
Plug 'miyakogi/seiya.vim'
Plug 'crusoexia/vim-monokai'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

"
"\ \     /_ _|  \  | __ __| _ \   _ \  |
" \ \   /   |  |\/ |    |  |   | |   | |
"  \ \ /    |  |   |    |  |   | |   | |
"   \_/   ___|_|  _|   _| \___/ \___/ _____|
"
"if !has('nvim')
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
"endif

Plug 'ybian/smartim'
"Plug 'rlue/vim-barbaric'
Plug 'lyokha/vim-xkbswitch'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'benmills/vimux'
Plug 'vim-scripts/Auto-Pairs'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'ervandew/supertab'
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
"Plug 'xavierchow/vim-swagger-preview', {'for': ['yaml']}
Plug '~/Tool_from_git/fzf/bin/fzf'
Plug '~/Tool_from_git/fzf/bin/fzf-tmux'
Plug 'junegunn/fzf.vim'
Plug 'wannesm/wmgraphviz.vim', {'for': ['dot']}
Plug 'lilydjwg/colorizer'
Plug 'luochen1990/rainbow'
Plug 'inside/vim-search-pulse'
Plug 'mhinz/vim-grepper'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'slim-template/vim-slim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'mileszs/ack.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', {
            \ 'do': 'npm install',
            \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

"Plug 'vimwiki/vimwiki'
"Plug 'dbeniamine/cheat.sh-vim'

"
"  ___|\ \   /  \  |__ __|  \  \ \  /
"\___ \ \   /    \ |   |   _ \  \  /
"      |   |   |\  |   |  ___ \    \
"_____/   _|  _| \_|  _|_/    _\_/\_\
"

"if !has('nvim')
  "Plug 'stamblerre/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

  " for deoplete
  "Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
  "Plug 'Shougo/neco-vim'
  "Plug 'deoplete-plugins/deoplete-jedi'
  "Plug 'deoplete-plugins/deoplete-dictionary'
  "Plug 'deoplete-plugins/deoplete-docker'
"endif

"Plug 'zxqfl/tabnine-vim'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'ferrine/md-img-paste.vim', {'for': ['markdown']}
"Plug 'shime/vim-livedown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'dhruvasagar/vim-table-mode'
Plug 'rhysd/vim-grammarous'
Plug 'vim-syntastic/syntastic'
Plug 'heavenshell/vim-pydocstring'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'chr4/nginx.vim'
Plug 'PProvost/vim-ps1' "ps1
Plug 'wookiehangover/jshint.vim'
Plug 'stevearc/vim-arduino'
Plug 'junegunn/gv.vim'
Plug 'mattn/webapi-vim' " dependency for gist-vim
Plug 'mattn/gist-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'junegunn/vader.vim'
"Plug 'davidhalter/jedi-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'hashivim/vim-terraform'
"Plug 'Valloric/YouCompleteMe',{
            "\ 'do': 'python3 install.py --go-completer --ts-completer --java-completer --clang-completer',
            "\ 'for': ['javascript', 'c', 'cpp', 'python', 'go']}

"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/asyncomplete.vim'

"Plug 'wellle/tmux-complete.vim'
"Plug 'shawncplus/phpcomplete.vim'
"Plug 'stanangeloff/php.vim'
"Plug 'Rip-Rip/clang_complete'
"Plug 'hdima/python-syntax'
"Plug 'keith/swift.vim'
"Plug 'vim-scripts/Conque-GDB'
"Plug 'artur-shaik/vim-javacomplete2'
"Plug 'juliosueiras/vim-terraform-completion'

" bash-support
" https://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin

" ____|  _ \   _ \   \  |__ __| ____|  \  | __ \
" |     |   | |   |   \ |   |   __|     \ | |   |
" __|   __ <  |   | |\  |   |   |     |\  | |   |
"_|    _| \_\\___/ _| \_|  _|  _____|_| \_|____/

"if filereadable(expand('~/.frontend.vimenv'))
" syntax
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'alvan/vim-closetag', {'for': 'html'}
Plug 'cakebaker/scss-syntax.vim', {'for': 'scss'}
Plug 'hail2u/vim-css3-syntax', {'for': 'css'}
Plug 'isRuslan/vim-es6', {'for': 'javascript'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'othree/yajs.vim', {'for': 'javascript'}
Plug 'posva/vim-vue', {'for': 'javascript'}
Plug 'digitaltoad/vim-pug', {'for': 'html'}

"  _ \__ __| |   | ____|  _ \
" |   |  |   |   | __|   |   |
" |   |  |   ___ | |     __ <
"\___/  _|  _|  _|_____|_| \_\
Plug 'mattn/emmet-vim'


let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

call plug#end()

filetype plugin indent on

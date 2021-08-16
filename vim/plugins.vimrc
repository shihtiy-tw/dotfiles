"__     _____ __  __   ____  _    _   _  ____
"\ \   / /_ _|  \/  | |  _ \| |  | | | |/ ___|
" \ \ / / | || |\/| | | |_) | |  | | | | |  _
"  \ V /  | || |  | | |  __/| |__| |_| | |_| |
"   \_/  |___|_|  |_| |_|   |_____\___/ \____|
"

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ gttps://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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

"IDE
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'

Plug 'junegunn/vim-peekaboo' "see the content of registers
Plug 'easymotion/vim-easymotion' "align text ga
Plug 'godlygeek/tabular' "aligning text :Tab/:
Plug 'scrooloose/nerdtree'
Plug 'junegunn/vim-easy-align'
Plug 'mg979/vim-visual-multi'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'triglav/vim-visual-increment'

"Input switch
"Plug 'ybian/smartim'
"Plug 'rlue/vim-barbaric'
"Plug 'lyokha/vim-xkbswitch'

"NERDTree
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'

"Git
Plug 'junegunn/gv.vim' " git commiter browser
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"Pretty
Plug 'Yggdroot/indentLine' "display the vertical lines at each indentation level
Plug 'vim-scripts/Auto-Pairs'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }  "show colow for colowcode
Plug 'luochen1990/rainbow' "colorize parentheses
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround' "Change the surround parentheses

Plug 'vim-scripts/matchit.zip' "to configure % to match more than just single characters
Plug 'inside/vim-search-pulse' "highlight the search
Plug 'Shougo/vimproc.vim', {'do' : 'make'} "vimproc is a great asynchronous execution library for Vim
"

"Format
Plug 'editorconfig/editorconfig-vim'
Plug 'Chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', {
            \ 'do': 'npm install',
            \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }


"Plug 'ervandew/supertab' "Supertab is a vim plugin which allows you to use <Tab> for all your insert completion needs
"Plug 'vim-scripts/Buffergator'
"Plug 'vimwiki/vimwiki'
"Plug 'mileszs/ack.vim'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'dbeniamine/cheat.sh-vim'
"Plug 'mhinz/vim-grepper'
"Plug 'wannesm/wmgraphviz.vim', {'for': ['dot']}
"Plug '~/Tool_from_git/fzf/bin/fzf'
"Plug '~/Tool_from_git/fzf/bin/fzf-tmux'

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

"GO
Plug 'fatih/vim-go', {'for': ['go']}

"Markdown
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'dhruvasagar/vim-table-mode'
"Plug 'ferrine/md-img-paste.vim', {'for': ['markdown']}
"Plug 'shime/vim-livedown'

"Swagger API
"Plug 'xavierchow/vim-swagger-preview', {'for': ['yaml']}

"Grammar
Plug 'rhysd/vim-grammarous'

"Python
Plug 'heavenshell/vim-pydocstring'

"Nginx
Plug 'chr4/nginx.vim' "nginx config highlight

"Arduino
" Plug 'stevearc/vim-arduino'

"Terraform
Plug 'hashivim/vim-terraform'

"Docker
Plug 'ekalinin/Dockerfile.vim'

" Vimscript test
Plug 'junegunn/vader.vim'

"Plug 'Valloric/YouCompleteMe',{
            "\ 'do': 'python3 install.py --go-completer --ts-completer --java-completer --clang-completer',
            "\ 'for': ['javascript', 'c', 'cpp', 'python', 'go']}

"Plug 'davidhalter/jedi-vim'
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
" Plug '2072/PHP-Indenting-for-VIm'
" Plug 'wookiehangover/jshint.vim'

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

" _                   _             _  __
"| |    ___  __ _  __| | ___ _ __  | |/ /___ _   _
"| |   / _ \/ _` |/ _` |/ _ \ '__| | ' // _ \ | | |
"| |__|  __/ (_| | (_| |  __/ |    | . \  __/ |_| |
"|_____\___|\__,_|\__,_|\___|_|    |_|\_\___|\__, |
"                                            |___/

let mapleader=" "

" ___   ___ _  __ __     _____ __  __
"/ _ \ / _ (_)/ / \ \   / /_ _|  \/  |
" (_) | | | |/ /   \ \ / / | || |\/| |
"\__, | |_| / /_    \ V /  | || |  | |
"  /_/ \___/_/(_)    \_/  |___|_|  |_|
"
" fuzzy find
set path +=**
set wildmenu

" print current filename
" echo expane("%")

" TAG JUMPING:

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack
"
" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" _____            _   _         __     ___
"|  ___|__  _ __  | \ | | ___  __\ \   / (_)_ __ ___
"| |_ / _ \| '__| |  \| |/ _ \/ _ \ \ / /| | '_ ` _ \
"|  _| (_) | |    | |\  |  __/ (_) \ V / | | | | | | |
"|_|  \___/|_|    |_| \_|\___|\___/ \_/  |_|_| |_| |_|
"

" Terminal
if has('nvim')
    autocmd BufEnter term://* startinsert
    " To map <Esc> to exit terminal-mode:
    "tnoremap <Esc> <C-\><C-n>
    "tnoremap <M-[> <Esc>
    "tnoremap <C-v><Esc> <Esc>
    tnoremap <Leader><Leader> <C-\><C-n>

    " To use `ALT+{h,j,k,l}` to navigate windows from any mode:
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

    function! VspTerm()
        vsp term://zsh
    endfunction

    function! SpTerm()
        sp term://zsh
    endfunction

    function! TTerm()
        tabnew term://zsh
    endfunction

    command! Vspt call VspTerm()
    command! Spt call SpTerm()
    command! Tt call TTerm()

    tnoremap <A-v> :Vspt <cr>
    tnoremap <A-s> :Spt <cr>
    tnoremap <A-t> :Tt <cr>
    inoremap <A-v> :Vspt <cr>
    inoremap <A-s> :Spt <cr>
    inoremap <A-t> :Tt <cr>
    nnoremap <A-v> :Vspt <cr>
    nnoremap <A-s> :Spt <cr>
    nnoremap <A-t> :Tt <cr>

endif


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
"Plug 'Shougo/vimproc.vim', {'do' : 'make'}

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
"Plug 'easymotion/vim-easymotion'

Plug 'mhinz/vim-grepper'
Plug 'rking/ag.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
"Plug 'vimwiki/vimwiki'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"Plug 'idanarye/vim-vebugger'
"Plug 'vim-vdebug/vdebug'
"https://www.raditha.com/blog/archives/vim-and-python-debug/

Plug 'stevearc/vim-arduino'
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'wesleyche/SrcExpl'



" Syntax
"Plug 'vim-scripts/Conque-GDB'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'chr4/nginx.vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'stanangeloff/php.vim'
Plug 'hdima/python-syntax'
Plug 'keith/swift.vim'
Plug 'davidhalter/jedi-vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'PProvost/vim-ps1' "ps1
"Plug 'Rip-Rip/clang_complete'
Plug 'wookiehangover/jshint.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', {
            \ 'do': 'npm install',
            \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

" Plug 'maralla/validator.vim'


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

" Command Tool
Plug 'mileszs/ack.vim'


" Misc
Plug 'mattn/webapi-vim' " dependency for gist-vim
Plug 'mattn/gist-vim'
Plug 'editorconfig/editorconfig-vim'
" bash-support
" https://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin


" _   _         __     ___             ____  _             _
"| \ | | ___  __\ \   / (_)_ __ ___   |  _ \| |_   _  __ _(_)_ __  ___
"|  \| |/ _ \/ _ \ \ / /| | '_ ` _ \  | |_) | | | | |/ _` | | '_ \/ __|
"| |\  |  __/ (_) \ V / | | | | | | | |  __/| | |_| | (_| | | | | \__ \
"|_| \_|\___|\___/ \_/  |_|_| |_| |_| |_|   |_|\__,_|\__, |_|_| |_|___/
"                                                    |___/

if has('.nvim')
  Plug 'sakhnik/nvim-gdb'
  Plug 'SkyLeach/pudb.vim'
  "Plug 'Shougo/neocomplete'
endif

let local_Vimrc=expand('~/.vimrc.local')
if filereadable(local_Vimrc)
    source ~/.vimrc.local
endif

call plug#end()
filetype plugin indent on


" _____ _
"|_   _| |__   ___ _ __ ___   ___
"  | | | '_ \ / _ \ '_ ` _ \ / _ \
"  | | | | | |  __/ | | | | |  __/
"  |_| |_| |_|\___|_| |_| |_|\___|


let g:rehash256 = 1
let option = "molokai"
if option == "molokai"
    if !empty(glob('~/.vim/plugged/molokai/colors/molokai.vim'))
        color molokai
    endif
elseif option == "monokai"
    if !empty(glob('~/.vim/plugged/vim-monokai/colors/monokai.vim'))
        color monokai
    endif
elseif option == "solarized"
    if !empty(glob('~/.vim/plugged/vim-colors-solarized/colors/solarized.vim'))
        set background=dark
        let g:solarized_termcolors=256
        color solarized
    endif
endif

" ____            _         ____             __ _
"| __ )  __ _ ___(_) ___   / ___|___  _ __  / _(_) __ _
"|  _ \ / _` / __| |/ __| | |   / _ \| '_ \| |_| |/ _` |
"| |_) | (_| \__ \ | (__  | |__| (_) | | | |  _| | (_| |
"|____/ \__,_|___/_|\___|  \____\___/|_| |_|_| |_|\__, |
"                                                 |___/
"
set autoindent                   " 自動縮排
set backspace=indent,eol,start   " 統一 backsapce 功能
set colorcolumn=81               " 換行提示線
set cursorline                   " 目前游標所在這行反白
set fileencodings=utf-8,default,big5,ucs-bom,latin1
set hlsearch                     " 顏色標記被搜尋的文字
set ignorecase                   " 搜尋忽略大小寫
set incsearch                    " 往後搜尋
set nobackup                     " 關閉備份檔案
set noswapfile                   " 不使用 swapfile
set nowritebackup                " 關閉備份檔案
set number                       " 顯示行數
set ruler                        " 游標位置資訊
set scrolloff=3                  " 游標距離上下 N 行開始捲動螢幕
set showcmd                      " 顯示命令按鍵
set smartcase                    " 搜尋時自動判斷是否區分大小寫
set smartindent                  " 自動縮排
set t_Co=256                     " 啟用256色彩空間
set tabpagemax=100               " 一次最多可以開多少tab
set timeoutlen=300               " escape delay
set wildmenu                     " 自動補完選單
set splitbelow                   " 切割下方螢幕
set splitright                   " 切割右方螢幕
set tabstop=2                    " tab寬度
set shiftwidth=2                 " tab 寬度
set expandtab                    " tab 變成 spaces
" set spell! spelllang=en_us         " 拼音檢查

syntax on
filetype plugin indent on

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" _____ _ _     _____                   ____      _       _           _
"|  ___(_) | __|_   _|   _ _ __   ___  |  _ \ ___| | __ _| |_ ___  __| |
"| |_  | | |/ _ \| || | | | '_ \ / _ \ | |_) / _ \ |/ _` | __/ _ \/ _` |
"|  _| | | |  __/| || |_| | |_) |  __/ |  _ <  __/ | (_| | ||  __/ (_| |
"|_|   |_|_|\___||_| \__, | .__/ \___| |_| \_\___|_|\__,_|\__\___|\__,_|
"                    |___/|_|
"
autocmd FileType python       setlocal  ts=4 sw=4 sts=4 cc=80 et
autocmd FileType c            setlocal  ts=4 sw=4 sts=4 cc=80 et
autocmd FileType html         setlocal  sw=2 sts=2            et
autocmd FileType javascript   setlocal  sw=2 sts=2            et
autocmd FileType ruby         setlocal  sw=2 sts=2            noet
autocmd FileType php          setlocal                        et

" _  __            __  __                   _
"| |/ /___ _   _  |  \/  | __ _ _ __  _ __ (_)_ __   __ _
"| ' // _ \ | | | | |\/| |/ _` | '_ \| '_ \| | '_ \ / _` |
"| . \  __/ |_| | | |  | | (_| | |_) | |_) | | | | | (_| |
"|_|\_\___|\__, | |_|  |_|\__,_| .__/| .__/|_|_| |_|\__, |
"          |___/               |_|   |_|            |___/

"normal mode
imap <Leader><Leader> <c-c>

" pydocstring
nmap <leader><leader>c <Plug>(pydocstring)


" vim-instance-markdown
map <leader>md :InstantMarkdownPreview<CR>

" clear search result
" nnoremap <c-l> :noh<CR>
" inoremap <c-l> <c-o>:noh<CR>
nnoremap <Leader>m :noh<CR>
" inoremap <Leader>m :noh<CR>
nmap <Leader>m :noh<CR>

" Grepper
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
"nnoremap <leader>gj :Grepper -tool git<cr>
"nnoremap <leader>GJ :Grepper -tool ag<cr>
nnoremap <leader>gj :Grepper -tool grep<cr>
nnoremap <leader>GJ :Grepper -tool ag<cr>

" reload files
function! ReloadFilessss()
    "set autoreload
    set autoread
    checktime
    set noautoread
endfunction

noremap <F5> :call ReloadFilessss() <CR>

" Synstatic
nnoremap <F4> :SyntasticToggleMode <CR>
"nnoremap <F4> :SyntasticCheck <CR>

" vim-autoformat
nnoremap <F3> :Autoformat <CR>

" YouCompleteMe
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration <CR>
nnoremap <leader>gy :YcmCompleter GoToReferences <CR>
" python3 install.py --go-completer --ts-completer --java-completer --clang-completer --cs-completer

"arduino
nnoremap <buffer> <leader>am :ArduinoVerify<CR>
nnoremap <buffer> <leader>au :ArduinoUpload<CR>
nnoremap <buffer> <leader>ad :ArduinoUploadAndSerial<CR>
nnoremap <buffer> <leader>ab :ArduinoChooseBoard<CR>
nnoremap <buffer> <leader>ap :ArduinoChooseProgrammer<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>

" NERDTree
inoremap <F9> <ESC>:NERDTreeTabsToggle<CR>
nnoremap <silent> <F9> :NERDTreeTabsToggle<CR>
let g:NERDTreeWinSize=22
let NERDTreeIgnore=['__pycache__', '\.o$', '\.pyc$', '\~$', 'node_modules', '\.dSYM$', '\.class$']

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" CtrlP
" ctags -R
"Ctrl+] - go to definition  -> shift-k //show definition
"Ctrl+T - Jump back from the definition.
"Ctrl+W Ctrl+] - Open the definition in a horizontal split
nmap <Leader>f :CtrlP<CR>
nmap <leader>. :CtrlPTag<CR>
nmap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" tabs
nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabedit

" emmet
imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
imap <c-k> <esc>:call emmet#moveNextPrev(1)<CR>

" gitgutter
nmap <Leader>ha :GitGutterStageHunk<CR>
nmap <Leader>hu :GitGutterRevertHunk<CR>
nmap <Leader>hv :GitGutterPreviewHunk<CR>

" SrcExpl
nmap <F10> :SrcExplToggle<CR>


" move in panels
nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

" evil shift!
cab Q q
cab Qa qa
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

" integration with system clipboard
map <leader>p "*p
map <leader>y "*y

" javacomplete2
inoremap ,, <C-x><C-o>

" zoom toggle
nmap <leader>z :tabnew %<CR>
nmap <leader>Z :q<CR>

" spell checking
nmap <F2> :set spell! spelllang=en_us <CR>

" bash support
autocmd filetype shell nmap <leader>h :!open ~/.vim/bash-support/doc/bash-hot-keys.pdf <CR>

"wmgraphviz
"autocmd bufnewfile *.dot call Headerdot()
function Headerdot()
   call setline(1,"//usr/bin/dot")
   call append(1,"digraph G{")
   call append(2,"")
   call append(3,"}")
   normal 3G
endf

"graphviz
"let g:WMGraphviz_dot = "dot"
"let g:WMGraphviz_output = "png"
"let g:WMGraphviz_viewer = "xdg-open"
"let g:WMGraphviz_shelloptions = ""
nmap <leader>ll :GraphvizCompile <CR>
nmap <leader>lv :GraphvizShow <CR>

" _____                     _   _
"| ____|_  _____  ___ _   _| |_(_) ___  _ __
"|  _| \ \/ / _ \/ __| | | | __| |/ _ \| '_ \
"| |___ >  <  __/ (__| |_| | |_| | (_) | | | |
"|_____/_/\_\___|\___|\__,_|\__|_|\___/|_| |_|

"autocmd filetype c          nnoremap <leader>r :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
"autocmd filetype cs         nnoremap <leader>r :w <bar> exec '!mcs '.shellescape('%').' && mono '.shellescape('%:r').'.exe'<CR>
"autocmd filetype cpp        nnoremap <leader>r :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
"autocmd filetype php        nnoremap <leader>r :w <bar> exec '!php -f '.shellescape('%') <CR>
"autocmd filetype java       nnoremap <leader>r :w <bar> exec '!javac '.shellescape('%').'&&java '.shellescape('%:r') <CR>
"autocmd filetype lisp       nnoremap <leader>r :w <bar> exec '!clisp '.shellescape('%') <CR>
"autocmd filetype perl       nnoremap <leader>r :w <bar> exec '!perl '.shellescape('%') <CR>
"autocmd filetype ruby       nnoremap <leader>r :w <bar> exec '!ruby '.shellescape('%') <CR>
"autocmd filetype shell      nnoremap <leader>r :w <bar> exec '!bash '.shellescape('%') <CR>
"autocmd filetype python     nnoremap <leader>r :w <bar> exec '!python3 '.shellescape('%')<CR>
"autocmd filetype javascript nnoremap <leader>r :w <bar> exec '!nodejs '.shellescape('%') <CR>


"for fish
"autocmd filetype c          nnoremap <leader>r :w <bar> exec '!gcc '.shellescape('%').' -O2 ; and  ./a.out'<CR>
"autocmd filetype cs         nnoremap <leader>r :w <bar> exec '!mcs '.shellescape('%').' ; and  mono '.shellescape('%:r').'.exe'<CR>
"autocmd filetype cpp        nnoremap <leader>r :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 ; and  ./a.out'<CR>
"autocmd filetype php        nnoremap <leader>r :w <bar> exec '!php -f '.shellescape('%') <CR>
"autocmd filetype java       nnoremap <leader>r :w <bar> exec '!javac '.shellescape('%').'; and java '.shellescape('%:r') <CR>
autocmd filetype c          nnoremap <leader>r :w <bar> exec '!gcc '.shellescape('%').' -O2 &&  ./a.out'<CR>
autocmd filetype cs         nnoremap <leader>r :w <bar> exec '!mcs '.shellescape('%').' &&  mono '.shellescape('%:r').'.exe'<CR>
autocmd filetype cpp        nnoremap <leader>r :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 &&  ./a.out'<CR>
autocmd filetype php        nnoremap <leader>r :w <bar> exec '!php -f '.shellescape('%') <CR>
autocmd filetype java       nnoremap <leader>r :w <bar> exec '!javac '.shellescape('%').'&& java '.shellescape('%:r') <CR>
autocmd filetype lisp       nnoremap <leader>r :w <bar> exec '!clisp '.shellescape('%') <CR>
autocmd filetype perl       nnoremap <leader>r :w <bar> exec '!perl '.shellescape('%') <CR>
autocmd filetype ruby       nnoremap <leader>r :w <bar> exec '!ruby '.shellescape('%') <CR>
autocmd filetype shell      nnoremap <leader>r :w <bar> exec '!bash '.shellescape('%') <CR>
autocmd filetype python     nnoremap <leader>r :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype javascript nnoremap <leader>r :w <bar> exec '!nodejs '.shellescape('%') <CR>

" ____  _             _              ____             __ _
"|  _ \| |_   _  __ _(_)_ __  ___   / ___|___  _ __  / _(_) __ _
"| |_) | | | | |/ _` | | '_ \/ __| | |   / _ \| '_ \| |_| |/ _` |
"|  __/| | |_| | (_| | | | | \__ \ | |__| (_) | | | |  _| | (_| |
"|_|   |_|\__,_|\__, |_|_| |_|___/  \____\___/|_| |_|_| |_|\__, |
"               |___/                                      |___/

" Ctags
let g:ctags_statusline = 1

" Arduino
let g:arduino_serial_tmux = ''
let g:arduino_verify_tmux = ''
let g:arduino_upload_tmux = ''

" my_file.ino [arduino:avr:uno] [arduino:usbtinyisp] (/dev/ttyACM0:9600)
function! MyStatusLine()
    let port = arduino#GetPort()
    let line = '%f [' . g:arduino_board . '] [' . g:arduino_programmer . ']'
    if !empty(port)
        let line = line . ' (' . port . ':' . g:arduino_serial_baud . ')'
    endif
    return line
endfunction
setl statusline=%!MyStatusLine()

autocmd BufNewFile,BufRead *.ino let g:airline_section_x='%{MyStatusLine()}'

" pudb
"if has('nvim')
  "let g:python_host_prog='/usr/bin/python3.6'
  "let g:python3_host_prog='/usr/bin/python3.6'
  "" set the virtual env python used to launch the debugger
  "let g:pudb_python='/usr/bin/python3.6'
  "" set the entry point (script) to use for pudb
  "let g:pudb_entry_point='~/src/poweruser_tools/test/test_templates.py'
  "" Unicode symbols work fine (nvim, iterm, tmux, nyovim tested)
  "let g:pudb_breakpoint_symbol='*'
"endif

" SrcExpl
let g:SrcExpl_pluginList = [
    \"__Tagbar__.1",
    \"NERD_tree_1"
    \]
" // Set the height of Source Explorer window
let g:SrcExpl_winHeight = 8

" // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_refreshTime = 100

" // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_jumpKey = "<ENTER>"

" // Set "Space" key for back from the definition context
let g:SrcExpl_gobackKey = "<SPACE>"

" ConqueGDB
let g:ConqueTerm_Color=2            " 1: strip color after 200 line, 2: always with color
"let g:ConqueTerm_CloseOnEnd=1       " close conque when program ends running
let g:ConqueTerm_StartMessages=0    " display warning message if conqueTerm is configed incorrect

" bash support
let g:BASH_AuthorName = 'Stanley Yuan'
let g:BASH_Email = 'None'
let g:BASH_Company = 'None'

" Autoformat
" show error
let g:autoformat_verbosemode=1
" OR:
let verbose=1
" python
" pip3 install --upgrade autopep8 --user
" pip3 install --upgrade black --user
let g:formatdef_custom_black = '"black -q  - --line-length 91"'
let g:formatters_python = ['custom_black']

" javascript
" npm install -g js-beautify
let g:formatdef_custom_js_beautify = '"js-beautify - --indent-size 2"'
let g:formatters_javascript = ['custom_js_beautify']

" c/c++
" apt install clang-format
"let g:formatdef_custom_clang_format = '"clang-format - -style=\"{BasedOnStyle: Google, AlignTrailingComments: true, UseTab: Never, IndentWidth: 4}\""'
let g:formatdef_custom_clang_format = '"clang-format - -style=\"{BasedOnStyle: WebKit, AlignTrailingComments: true, UseTab: Never, IndentWidth: 4}\""'
"let g:formatdef_custom_clang_format = '"clang-format - "'
let g:formatters_c = ['custom_clang_format']

" Prettier
let g:prettier#config#tab_width = 2

" gitgutter
set updatetime=100

" Ag
let g:ag_working_path_mode="r"
let g:ag_lhandler=""
ca Ag Ag!

"supertab
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabClosePreviewOnPopupClose = 1

" vimwiki
"let g:vimwiki_list = [{'path': '~/my_site/',
"\ 'syntax': 'markdown', 'ext': '.md'}]
"# hotkeys
"Enter - create a new note (cursor must be on a word)
"Enter - enter into the note
"Backspace - Go back

" fugitive
set diffopt+=vertical

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastuc_javascript_checkers = ['jshint']
let g:syntastic_python_pylint_args = "--load-plugins pylint_django"
let g:syntastic_python_flake8_post_args='--ignore=F821,E302,E501,F403,F405,E731,W503'
let g:syntastic_python_pyflakes_exe = 'python3 -m pyflakes'
"pylint --generate-rcfile > ~/.pylintrc

let g:syntastic_mode_map = {
            \ "mode": "passive",
            \ "active_filetypes": [],
            \ "passive_filetypes": [] }

" let g:syntastic_c_checkers = [ 'gcc' ]

" YCM
" for c family
" let g:ycm_show_diagnostics_ui = 0
let g:EclimFileTypeValidate = 0
"let g:ycm_filetype_blacklist = { 'python': 1 }


autocmd filetype c let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
autocmd filetype cpp let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf_cpp.py"
let g:clang_use_library = 1
let g:clang_library_path = "/usr/lib/llvm-3.8/lib/libclang.so"

" grepper
let g:grepper_highlight = 1

" vim-instant-markdown - Instant Markdown previews from Vim
" https://github.com/suan/vim-instant-markdown
let g:instant_markdown_autostart = 0    " disable autostart
"# hotkeys
"<leader>md - Open Markdown preview on web browser
"related tools: gitbook, remarkable

" Emmet
let g:user_emmet_expandabbr_key = '<c-e>'

" CtrlP
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules)$',
            \ 'file': '\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$',
            \ }

" python-syntax
let python_highlight_all = 1

" vim-css3-syntax
augroup VimCSS3Syntax
    autocmd!

    autocmd FileType css setlocal iskeyword+=-
augroup END

" vim-surround
let g:surround_45="<% \r %>"   " -
let g:surround_61="<%= \r %>"  " =
let g:surround_33="<!-- \r -->" "!
let g:surround_42="/* \r */" "*

" localvimrc
let g:localvimrc_persistent=1

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='minimalist'

" vim-javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete


"source ~/.vim/neocomplete.config.vim
"

" seiya

"  ___  _   _
" / _ \| |_| |__   ___ _ __
"| | | | __| '_ \ / _ \ '__|
"| |_| | |_| | | |  __/ |
" \___/ \__|_| |_|\___|_|

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

hi Search ctermfg=16 ctermbg=226

if has("gui_macvim") || has("gui_vimr")
    set guifont=Menlo:h14
endif

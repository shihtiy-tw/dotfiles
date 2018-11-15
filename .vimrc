" _                   _             _  __
"| |    ___  __ _  __| | ___ _ __  | |/ /___ _   _
"| |   / _ \/ _` |/ _` |/ _ \ '__| | ' // _ \ | | |
"| |__|  __/ (_| | (_| |  __/ |    | . \  __/ |_| |
"|_____\___|\__,_|\__,_|\___|_|    |_|\_\___|\__, |
"                                            |___/

let mapleader=" "

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
Plug '2072/PHP-Indenting-for-VIm'
Plug 'shawncplus/phpcomplete.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"Plug 'idanarye/vim-vebugger'
Plug 'vim-vdebug/vdebug'
"https://www.raditha.com/blog/archives/vim-and-python-debug/



"Plug 'Shougo/neocomplete'


" Syntax
Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'chr4/nginx.vim'
Plug 'stanangeloff/php.vim'
Plug 'hdima/python-syntax'

Plug 'keith/swift.vim'

Plug 'davidhalter/jedi-vim'

Plug 'artur-shaik/vim-javacomplete2'
Plug 'PProvost/vim-ps1' "ps1

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

set autoindent                   " 自動縮排
set backspace=indent,eol,start   " 統一 backsapce 功能
set colorcolumn=100              " 換行提示線
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
set shiftwidth=4                 " tab 寬度
set showcmd                      " 顯示命令按鍵
set smartcase                    " 搜尋時自動判斷是否區分大小寫
set smartindent                  " 自動縮排
set t_Co=256                     " 啟用256色彩空間
set tabpagemax=100               " 一次最多可以開多少tab
set tabstop=4                    " tab寬度
set timeoutlen=300               " escape delay
set wildmenu                     " 自動補完選單

syntax on
filetype plugin indent on

" _____ _ _     _____                   ____      _       _           _
"|  ___(_) | __|_   _|   _ _ __   ___  |  _ \ ___| | __ _| |_ ___  __| |
"| |_  | | |/ _ \| || | | | '_ \ / _ \ | |_) / _ \ |/ _` | __/ _ \/ _` |
"|  _| | | |  __/| || |_| | |_) |  __/ |  _ <  __/ | (_| | ||  __/ (_| |
"|_|   |_|_|\___||_| \__, | .__/ \___| |_| \_\___|_|\__,_|\__\___|\__,_|
"                    |___/|_|

autocmd FileType python setlocal et   sw=4 sts=4 cc=80
autocmd FileType html   setlocal et   sw=2 sts=2
autocmd FileType ruby   setlocal noet sw=2 sts=2
autocmd FileType php    setlocal et

" _  __            __  __                   _
"| |/ /___ _   _  |  \/  | __ _ _ __  _ __ (_)_ __   __ _
"| ' // _ \ | | | | |\/| |/ _` | '_ \| '_ \| | '_ \ / _` |
"| . \  __/ |_| | | |  | | (_| | |_) | |_) | | | | | (_| |
"|_|\_\___|\__, | |_|  |_|\__,_| .__/| .__/|_|_| |_|\__, |
"          |___/               |_|   |_|            |___/

"normal mode
imap <Leader><Leader> <c-c>

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

"Synstatic
nnoremap <F5> :SyntasticToggleMode <CR>
nnoremap <F4> :SyntasticCheck <CR>

"YouCompleteMe
nnoremap <leader>y :YcmCompleter GoToDefinitionElseDeclaration <CR>
nnoremap <leader>gy :YcmCompleter GoToReferences <CR>

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

"jedi



" Ag
let g:ag_working_path_mode="r"

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

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }

" grepper
let g:grepper_highlight = 1

" vim-instant-markdown - Instant Markdown previews from Vim
" https://github.com/suan/vim-instant-markdown
let g:instant_markdown_autostart = 0	" disable autostart
"# hotkeys
"<leader>md - Open Markdown preview on web browser
"related tools: gitbook, remarkable

" Emmet
let g:user_emmet_expandabbr_key = '<c-e>'

" CtrlP
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

" _                   _             _  __
"| |    ___  __ _  __| | ___ _ __  | |/ /___ _   _
"| |   / _ \/ _` |/ _` |/ _ \ '__| | ' // _ \ | | |
"| |__|  __/ (_| | (_| |  __/ |    | . \  __/ |_| |
"|_____\___|\__,_|\__,_|\___|_|    |_|\_\___|\__, |
"                                            |___/

let mapleader=" "

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

highlight ColorColumn ctermbg=88 guibg=lightgrey

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

" ____  _             _              ____             __ _
"|  _ \| |_   _  __ _(_)_ __  ___   / ___|___  _ __  / _(_) __ _
"| |_) | | | | |/ _` | | '_ \/ __| | |   / _ \| '_ \| |_| |/ _` |
"|  __/| | |_| | (_| | | | | \__ \ | |__| (_) | | | |  _| | (_| |
"|_|   |_|\__,_|\__, |_|_| |_|___/  \____\___/|_| |_|_| |_|\__, |
"               |___/                                      |___/
"


"    \         |
"   _ \    __| |  /
"  ___ \  (      <
"_/    _\\___|_|\_\
"
" ack

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"__ __|                    _|
"   |  _ \  __|  __| _` | |    _ \   __| __ `__ \
"   |  __/ |    |   (   | __| (   | |    |   |   |
"  _|\___|_|   _|  \__,_|_|  \___/ _|   _|  _|  _|
"
" terraform

let g:terraform_fmt_on_save=1
let g:terraform_align=1


" __ \                   |      |
" |   |  _ \  _ \  __ \  |  _ \ __|  _ \
" |   |  __/ (   | |   | |  __/ |    __/
"____/ \___|\___/  .__/ _|\___|\__|\___|
"                 _|
"
" deoplete

set omnifunc=syntaxcomplete#Complete

autocmd FileType python call deoplete#custom#buffer_option('auto_complete', v:false)
autocmd FileType c call deoplete#custom#buffer_option('auto_complete', v:false)
autocmd FileType cpp call deoplete#custom#buffer_option('auto_complete', v:false)

let g:deoplete#omni_patterns = {}
call deoplete#custom#option('omni_patterns', {
  \ 'complete_method': 'omnifunc',
  \ 'terraform': '[^ *\t"{=$]\w*',
  \})
let g:deoplete#enable_at_startup = 1
call deoplete#initialize()

" (Optional)Hide Info(Preview) window after completions
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"  ___|                        |         |
"\___ \  |   | __ \   _ \  __| __|  _` | __ \
"      | |   | |   |  __/ |    |   (   | |   |
"_____/ \__,_| .__/ \___|_|   \__|\__,_|_.__/
"             _|
"
"supertab

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabClosePreviewOnPopupClose = 1

autocmd FileType ruby let g:SuperTabDefaultCompletionType = "<C-X><C-K>"



"  ___|       |           _)
" |      _ \  |  _ \   __| |_  /  _ \
" |     (   | | (   | |    |  /   __/
"\____|\___/ _|\___/ _|   _|___|\___|
"
" colorize

if !hasmapto("<Plug>Colorizer") && (!exists("g:colorizer_nomap") || g:colorizer_nomap == 0)
  nmap <unique> <Leader>co <Plug>Colorizer
endif


"  ___| |
" |     __|  _` |  _` |  __|
" |     |   (   | (   |\__ \
"\____|\__|\__,_|\__, |____/
"                |___/
"
" Ctags

let g:ctags_statusline = 1

"    \            |      _)
"   _ \    __| _` | |   | | __ \   _ \
"  ___ \  |   (   | |   | | |   | (   |
"_/    _\_|  \__,_|\__,_|_|_|  _|\___/
"
"arduino

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

" __ )             |                                        |
" __ \   _` |  __| __ \    __| |   | __ \  __ \   _ \   __| __|
" |   | (   |\__ \ | | | \__ \ |   | |   | |   | (   | |    |
"____/ \__,_|____/_| |_| ____/\__,_| .__/  .__/ \___/ _|   \__|
"                                   _|    _|
" bash support

let g:BASH_AuthorName = 'Stanley Yuan'
let g:BASH_Email = 'None'
let g:BASH_Company = 'None'

"    \          |          _|                            |
"   _ \   |   | __|  _ \  |    _ \   __| __ `__ \   _` | __|
"  ___ \  |   | |   (   | __| (   | |    |   |   | (   | |
"_/    _\\__,_|\__|\___/ _|  \___/ _|   _|  _|  _|\__,_|\__|
"
" vim-autoformat

" show error
let g:autoformat_verbosemode=1
" OR:
let verbose=1
" python
" pip3 install --upgrade autopep8 --user
" pip3 install --upgrade black --user
let g:formatdef_custom_black = '"black -q  - --line-length 79"'
let g:formatdef_custom_yapf = '"yapf  - --sytle google"'
let g:formatters_python = ['yapf']

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


"  _ \           |   |  _)
" |   |  __| _ \ __| __| |  _ \  __|
" ___/  |    __/ |   |   |  __/ |
"_|    _|  \___|\__|\__|_|\___|_|
"
" Prettier

let g:prettier#config#tab_width = 2

"  ___|_) |               |   |
" |     | __|  _` | |   | __| __|  _ \  __|
" |   | | |   (   | |   | |   |    __/ |
"\____|_|\__|\__, |\__,_|\__|\__|\___|_|
"            |___/
"
" gitgutter

set updatetime=100


" ____|_)      _) |  _)
" |     |  _` | | __| |\ \   / _ \
" __|   | (   | | |   | \ \ /  __/
"_|    _|\__, |_|\__|_|  \_/ \___|
"        |___/
"
" fugitive

set diffopt+=vertical

"  ___|                   |         |  _)
"\___ \  |   | __ \   __| __|  _` | __| |  __|
"      | |   | |   |\__ \ |   (   | |   | (
"_____/ \__, |_|  _|____/\__|\__,_|\__|_|\___|
"       ____/
"
" Synstatic

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
let g:syntastic_python_python_exec = 'python3'
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

"  ___|
" |      __| _ \ __ \  __ \   _ \  __|
" |   | |    __/ |   | |   |  __/ |
"\____|_|  \___| .__/  .__/ \___|_|
"                _|    _|
"
" Grepper

let g:grepper_highlight = 1

" ____|                          |
" __|   __ `__ \  __ `__ \   _ \ __|
" |     |   |   | |   |   |  __/ |
"_____|_|  _|  _|_|  _|  _|\___|\__|
"
" emmet

let g:user_emmet_expandabbr_key = '<c-e>'

"  ___| |        |  _ \
" |     __|  __| | |   |
" |     |   |    | ___/
"\____|\__|_|   _|_|
"
" CtrlP

let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules)$',
            \ 'file': '\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$',
            \ }

"  _ \        |   |                                   |
" |   | |   | __| __ \   _ \  __ \    __| |   | __ \  __|  _` |\ \  /
" ___/  |   | |   | | | (   | |   | \__ \ |   | |   | |   (   | `  <
"_|    \__, |\__|_| |_|\___/ _|  _| ____/\__, |_|  _|\__|\__,_| _/\_\
"      ____/                             ____/
"
" python-syntax

let python_highlight_all = 1


"  ___|          ___ /
" |      __|  __|  _ \
" |    \__ \\__ \   ) |
"\____|____/____/____/
"
" vim-css3-syntax

augroup VimCSS3Syntax
    autocmd!

    autocmd FileType css setlocal iskeyword+=-
augroup END


"  ___|                                 |
"\___ \  |   |  __|  __| _ \  __ \   _` |
"      | |   | |    |   (   | |   | (   |
"_____/ \__,_|_|   _|  \___/ _|  _|\__,_|
"
" vim-surround

let g:surround_45="<% \r %>"   " -
let g:surround_61="<%= \r %>"  " =
let g:surround_33="<!-- \r -->" "!
let g:surround_42="/* \r */" "*

" |                      |       _)
" |      _ \   __|  _` | |\ \   / | __ `__ \   __| __|
" |     (   | (    (   | | \ \ /  | |   |   | |   (
"_____|\___/ \___|\__,_|_|  \_/  _|_|  _|  _|_|  \___|
"
" localvimrc

let g:localvimrc_persistent=1


"    \   _)      |_)
"   _ \   |  __| | | __ \   _ \
"  ___ \  | |    | | |   |  __/
"_/    _\_|_|   _|_|_|  _|\___|
"
" airline

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='minimalist'

"     |                                              |      |       ___ \
"     |  _` |\ \   / _` |  __|  _ \  __ `__ \  __ \  |  _ \ __|  _ \   ) |
" \   | (   | \ \ / (   | (    (   | |   |   | |   | |  __/ |    __/  __/
"\___/ \__,_|  \_/ \__,_|\___|\___/ _|  _|  _| .__/ _|\___|\__|\___|_____|
"                                             _|
" javacomplete2

autocmd FileType java setlocal omnifunc=javacomplete#Complete

"  _ \        |
" |   | |   | __ \  |   |
" __ <  |   | |   | |   |
"_| \_\\__,_|_.__/ \__, |
"                  ____/
"
" ruby

"let g:ruby_host_prog = '/home/chris/.gem/ruby/2.4.0/bin/neovim-ruby-host.ruby2.4'
let g:ruby_host_prog = '/home/ieni/.gem/ruby/2.5.0/bin/neovim-ruby-host'

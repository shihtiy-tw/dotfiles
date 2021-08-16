" ____  _             _              ____             __ _
"|  _ \| |_   _  __ _(_)_ __  ___   / ___|___  _ __  / _(_) __ _
"| |_) | | | | |/ _` | | '_ \/ __| | |   / _ \| '_ \| |_| |/ _` |
"|  __/| | |_| | (_| | | | | \__ \ | |__| (_) | | | |  _| | (_| |
"|_|   |_|\__,_|\__, |_|_| |_|___/  \____\___/|_| |_|_| |_|\__, |
"               |___/                                      |___/
"
"  \  |     |      _)                                        |
" |\/ |  _` |       | __ `__ \   _` |       __ \   _` |  __| __|  _ \
" |   | (   |_____| | |   |   | (   |_____| |   | (   |\__ \ |    __/
"_|  _|\__,_|      _|_|  _|  _|\__, |       .__/ \__,_|____/\__|\___|
"                              |___/       _|
"
"md-img-paste

autocmd FileType markdown nmap <silent> <leader>P :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'


"                  |          |
"  __ \   _ \  _ \ |  /  _` | __ \   _ \   _ \
"  |   |  __/  __/   <  (   | |   | (   | (   |
"  .__/ \___|\___|_|\_\\__,_|_.__/ \___/ \___/
" _|

" Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.

"       |    |                   _) |        |
"\ \  / |  / __ \   __|\ \  \   / | __|  __| __ \
" `  <    <  |   |\__ \ \ \  \ /  | |   (    | | |
" _/\_\_|\_\_.__/ ____/  \_/\_/  _|\__|\___|_| |_|
"
" xkbuswitch

let g:XkbSwitchEnabled = 1
"let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.dylib'

" smarttim

let g:smartim_default = 'com.apple.keylayout.ABC'

"  \  |            |        |
" |\/ |  _` |  __| |  /  _` |  _ \\ \  \   / __ \
" |   | (   | |      <  (   | (   |\ \  \ /  |   |
"_|  _|\__,_|_|   _|\_\\__,_|\___/  \_/\_/  _|  _|
"
"markdown

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

"  _ \                 _)
" |   |  __| _ \\ \   / |  _ \\ \  \   /
" ___/  |    __/ \ \ /  |  __/ \ \  \ /
"_|    _|  \___|  \_/  _|\___|  \_/\_/
"
"preview

"set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {}
    \ }

" use a custom markdown style must be absolute path
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

function! g:Open_browser(url)
    silent exe 'silent !open -a "Safari" ' . a:url
endfunction
let g:mkdp_browserfunc = 'g:Open_browser'

"  ___|
" |     __ \  __ \  __ `__ \   _` | __ \
" |     |   | |   | |   |   | (   | |   |
"\____| .__/  .__/ _|  _|  _|\__,_|_|  _|
"      _|    _|
"
"cppman

command! -nargs=+ Cppman silent! call system("tmux split-window cppman " . expand(<q-args>))
autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>

"_ _|           |            |   |    _)
"  |  __ \   _` |  _ \ __ \  __| |     | __ \   _ \
"  |  |   | (   |  __/ |   | |   |     | |   |  __/
"___|_|  _|\__,_|\___|_|  _|\__|_____|_|_|  _|\___|
"
"indentline

" let g:indentLine_enabled = 1
" let g:vim_json_syntax_conceal = 0
" let g:indentLine_noConcealCursor='nc'
" let g:vim_json_syntax_conceal = 0
" :e $VIMRUNTIME/syntax/json.vim
" :g/if has('conceal')/s//& \&\& 0/
" :wq
" https://github.com/Yggdroot/indentLine/issues/140
let g:indentLine_concealcursor = ""

"    \    |     ____|
"   _ \   |     __|
"  ___ \  |     |
"_/    _\_____|_____|
"
"ale
"

" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

let g:ale_echo_msg_format = '%linter% says %s'

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5


"  ___|  _ \   ___|
" |     |   | |
" |     |   | |
"\____|\___/ \____|
"
"coc

if filereadable($HOME."/.vim/plugged/coc.nvim/plugin/coc.vim")

let g:coc_node_path = $NODEPATH

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

endif

"    \         |
"   _ \    __| |  /
"  ___ \  (      <
"_/    _\\___|_|\_\
"
" ack

"if filereadable($HOME."/.vim/plugged/ack.vim/plugin/ack.vim")
"
"if executable('ag')
"  let g:ackprg = 'ag --vimgrep'
"endif
"
"endif

"     |          |_)
"     |  _ \  _` | |
" \   |  __/ (   | |
"\___/ \___|\__,_|_|
"
"jedi

let g:jedi#rename_command = "<leader>rn"


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

if !has('nvim') && filereadable($HOME."/.vim/plugged/deoplete.nvim/plugin/deoplete.vim")

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
endif

"  ___|                        |         |
"\___ \  |   | __ \   _ \  __| __|  _` | __ \
"      | |   | |   |  __/ |    |   (   | |   |
"_____/ \__,_| .__/ \___|_|   \__|\__,_|_.__/
"             _|
"
"supertab

if filereadable($HOME."/.vim/plugged/supertab/plugin/supertab.vim")

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabClosePreviewOnPopupClose = 1

autocmd FileType ruby let g:SuperTabDefaultCompletionType = "<C-X><C-K>"

endif

"  ___|       |           _)
" |      _ \  |  _ \   __| |_  /  _ \
" |     (   | | (   | |    |  /   __/
"\____|\___/ _|\___/ _|   _|___|\___|
"
" colorize

if filereadable($HOME."/.vim/plugged/colorizer/plugin/colorizer.vim")

if !hasmapto("<Plug>Colorizer") && (!exists("g:colorizer_nomap") || g:colorizer_nomap == 0)
  nmap <unique> <Leader>co <Plug>Colorizer
endif

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

" Basic Usage
" Run :CtrlP or :CtrlP [starting-directory] to invoke CtrlP in find file mode.
" Run :CtrlPBuffer or :CtrlPMRU to invoke CtrlP in find buffer or find MRU file mode.
" Run :CtrlPMixed to search in Files, Buffers and MRU files at the same time.
" Check :help ctrlp-commands and :help ctrlp-extensions for other commands.
"
" Once CtrlP is open:
" Press <F5> to purge the cache for the current directory to get new files, remove deleted files and apply new ignore options.
" Press <c-f> and <c-b> to cycle between modes.
" Press <c-d> to switch to filename only search instead of full path.
" Press <c-r> to switch to regexp mode.
" Use <c-j>, <c-k> or the arrow keys to navigate the result list.
" Use <c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split.
" Use <c-n>, <c-p> to select the next/previous string in the prompt's history.
" Use <c-y> to create a new file and its parent directories.
" Use <c-z> to mark/unmark multiple files and <c-o> to open them.

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


"__ __|                                                     |      |
"   | __ `__ \  |   |\ \  /       __|  _ \  __ `__ \  __ \  |  _ \ __|  _ \
" | |   |   | |   | `  <_____| (    (   | |   |   | |   | |  __/ |    __/
"  _|_|  _|  _|\__,_| _/\_\     \___|\___/ _|  _|  _| .__/ _|\___|\__|\___|
"                                                    _|
" tmux-complete

let g:tmuxcomplete#asyncomplete_source_options = {
            \ 'name':      'tmuxcomplete',
            \ 'whitelist': ['*'],
            \ 'config': {
            \     'splitmode':      'words',
            \     'filter_prefix':   1,
            \     'show_incomplete': 1,
            \     'sort_candidates': 0,
            \     'scrollback':      0,
            \     'truncate':        0
            \     }
            \ }

"  _|     _|
" | _  / |
" __| /  __|
"_| ___|_|
"
"fzf

" |         |     |                                |
" __|  _` | __ \  |  _ \       __ `__ \   _ \   _` |  _ \
" |   (   | |   | |  __/_____| |   |   | (   | (   |  __/
"\__|\__,_|_.__/ _|\___|      _|  _|  _|\___/ \__,_|\___|
"
"dhruvasagar/vim-table-mode

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'


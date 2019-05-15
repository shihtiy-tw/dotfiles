" ____  _             _              ____             __ _
"|  _ \| |_   _  __ _(_)_ __  ___   / ___|___  _ __  / _(_) __ _
"| |_) | | | | |/ _` | | '_ \/ __| | |   / _ \| '_ \| |_| |/ _` |
"|  __/| | |_| | (_| | | | | \__ \ | |__| (_) | | | |  _| | (_| |
"|_|   |_|\__,_|\__, |_|_| |_|___/  \____\___/|_| |_|_| |_|\__, |
"               |___/                                      |___/
"

" ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
  cnoreabbrev Ack Ack!
  cnoreabbrev ack Ack!
  cnoreabbrev Ag Ack!
  "nnoremap <Leader>a :Ack!<Space>
  nnoremap <Leader>a :Ack!<cword><cr>
  noremap <Leader>A :Ack <Space>
endif

" terraform
let g:terraform_fmt_on_save=1
let g:terraform_align=1

"" neomake
"" When writing a buffer (no delay).
"call neomake#configure#automake('w')
"" When writing a buffer (no delay), and on normal mode changes (after 750ms).
"call neomake#configure#automake('nw', 750)
"" When reading a buffer (after 1s), and when writing (no delay).
"call neomake#configure#automake('rw', 1000)
"" Full config: when writing or reading a buffer, and on changes in insert and
"" normal mode (after 1s; no delay when writing).
"call neomake#configure#automake('nrwi', 500)

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

"supertab
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabClosePreviewOnPopupClose = 1

autocmd FileType ruby let g:SuperTabDefaultCompletionType = "<C-X><C-K>"



" colorize
if !hasmapto("<Plug>Colorizer") && (!exists("g:colorizer_nomap") || g:colorizer_nomap == 0)
  nmap <unique> <Leader>co <Plug>Colorizer
endif

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
let g:formatdef_custom_black = '"black -q  - --line-length 79"'
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

" ruby
"let g:ruby_host_prog = '/home/chris/.gem/ruby/2.4.0/bin/neovim-ruby-host.ruby2.4'
let g:ruby_host_prog = '/home/ieni/.gem/ruby/2.5.0/bin/neovim-ruby-host'

"source ~/.vim/neocomplete.config.vim
"

" seiya


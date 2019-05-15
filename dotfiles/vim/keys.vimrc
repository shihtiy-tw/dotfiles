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

" vim-livedown
nmap <Leader>md :LivedownToggle<CR>

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

"" SrcExpl
"nmap <F10> :SrcExplToggle<CR>


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
function! Headerdot()
   call setline(1,"//usr/bin/dot")
   call append(1,"digraph G{")
   call append(2,"")
   call append(3,"}")
   normal 3G
endfunction

"graphviz
"let g:WMGraphviz_dot = "dot"
"let g:WMGraphviz_output = "png"
"let g:WMGraphviz_viewer = "xdg-open"
"let g:WMGraphviz_shelloptions = ""
nmap <leader>ll :GraphvizCompile <CR>
nmap <leader>lv :GraphvizShow <CR>


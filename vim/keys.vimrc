" _  _________   __  __  __    _    ____  ____ ___ _   _  ____
"| |/ / ____\ \ / / |  \/  |  / \  |  _ \|  _ \_ _| \ | |/ ___|
"| ' /|  _|  \ V /  | |\/| | / _ \ | |_) | |_) | ||  \| | |  _
"| . \| |___  | |   | |  | |/ ___ \|  __/|  __/| || |\  | |_| |
"|_|\_\_____| |_|   |_|  |_/_/   \_\_|   |_|  |___|_| \_|\____|
"


"  \  |                            |   \  |           |
"   \ |  _ \   __| __ `__ \   _` | |  |\/ |  _ \   _` |  _ \
" |\  | (   | |    |   |   | (   | |  |   | (   | (   |  __/
"_| \_|\___/ _|   _|  _|  _|\__,_|_| _|  _|\___/ \__,_|\___|
"
"normal mode

imap <Leader><Leader> <c-c>

"  ___|  _ \   ___|
" |     |   | |
" |     |   | |
"\____|\___/ \____|
"
"coc

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> B :bd<cr>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"  _ \            |                 |       _)
" |   | |   |  _` |  _ \   __|  __| __|  __| | __ \   _` |
" ___/  |   | (   | (   | (   \__ \ |   |    | |   | (   |
"_|    \__, |\__,_|\___/ \___|____/\__|_|   _|_|  _|\__, |
"      ____/                                        |___/
"
"pydocstring

nmap <leader><leader>c <Plug>(pydocstring)

"\ \     /_)                 |_)                |
" \ \   /  | __ `__ \        | |\ \   / _ \  _` |  _ \\ \  \   / __ \
"  \ \ /   | |   |   |_____| | | \ \ /  __/ (   | (   |\ \  \ /  |   |
"   \_/   _|_|  _|  _|      _|_|  \_/ \___|\__,_|\___/  \_/\_/  _|  _|
"
" vim-livedown

nmap <Leader>md :LivedownToggle<CR>

"  ___| |                                           |
" |     |  _ \  _` |  __|   __|  _ \  _` |  __| __| __ \
" |     |  __/ (   | |    \__ \  __/ (   | |   (    | | |
" \____|_|\___|\__,_|_|    ____/\___|\__,_|_|  \___|_| |_|

"                       | |
"  __| _ \  __| |   | | __|
" |    __/\__ \ |   | | |
"_|  \___|____/\__,_|_|\__|
"
" clear search result

nnoremap <silent> <Leader>m :noh<CR>
nmap <silent> <Leader>m :noh<CR>

"  ___|
" |      __| _ \ __ \  __ \   _ \  __|
" |   | |    __/ |   | |   |  __/ |
"\____|_|  \___| .__/  .__/ \___|_|
"                _|    _|
"
" Grepper

nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
"nnoremap <leader>gj :Grepper -tool git<cr>
"nnoremap <leader>GJ :Grepper -tool ag<cr>
nnoremap <leader>gj :Grepper -tool grep<cr>
nnoremap <leader>GJ :Grepper -tool ag<cr>

"  _ \       |                 |   _|_) |
" |   |  _ \ |  _ \   _` |  _` |  |   | |  _ \  __|
" __ <   __/ | (   | (   | (   |  __| | |  __/\__ \
"_| \_\\___|_|\___/ \__,_|\__,_| _|  _|_|\___|____/
"
" reload files

function! ReloadFilessss()
    "set autoreload
    set autoread
    checktime
    set noautoread
endfunction

noremap <F5> :call ReloadFilessss() <CR>

"  ___|                   |         |  _)
"\___ \  |   | __ \   __| __|  _` | __| |  __|
"      | |   | |   |\__ \ |   (   | |   | (
"_____/ \__, |_|  _|____/\__|\__,_|\__|_|\___|
"       ____/
"
" Synstatic

nnoremap <F4> :SyntasticToggleMode <CR>
nnoremap <F4> :SyntasticCheck <CR>

"    \          |          _|                            |
"   _ \   |   | __|  _ \  |    _ \   __| __ `__ \   _` | __|
"  ___ \  |   | |   (   | __| (   | |    |   |   | (   | |
"_/    _\\__,_|\__|\___/ _|  \___/ _|   _|  _|  _|\__,_|\__|
"
" vim-autoformat

nnoremap <F3> :Autoformat <CR>

"\ \   /            ___|                       |      |         \  |
" \   / _ \  |   | |      _ \  __ `__ \  __ \  |  _ \ __|  _ \ |\/ |  _ \
"    | (   | |   | |     (   | |   |   | |   | |  __/ |    __/ |   |  __/
"   _|\___/ \__,_|\____|\___/ _|  _|  _| .__/ _|\___|\__|\___|_|  _|\___|
"                                       _|
" YouCompleteMe

"nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration <CR>
"nnoremap <leader>gy :YcmCompleter GoToReferences <CR>
" python3 install.py --go-completer --ts-completer --java-completer --clang-completer --cs-completer

"    \            |      _)
"   _ \    __| _` | |   | | __ \   _ \
"  ___ \  |   (   | |   | | |   | (   |
"_/    _\_|  \__,_|\__,_|_|_|  _|\___/
"
"arduino

nnoremap <buffer> <leader>am :ArduinoVerify<CR>
nnoremap <buffer> <leader>au :ArduinoUpload<CR>
nnoremap <buffer> <leader>ad :ArduinoUploadAndSerial<CR>
nnoremap <buffer> <leader>ab :ArduinoChooseBoard<CR>
nnoremap <buffer> <leader>ap :ArduinoChooseProgrammer<CR>

"__ __|           |
"   |  _` |  _` | __ \   _` |  __|
"   | (   | (   | |   | (   | |
"  _|\__,_|\__, |_.__/ \__,_|_|
"          |___/
"
" tagbar

nmap <F8> :TagbarToggle<CR>

"  \  | ____|  _ \  __ \__ __|
"   \ | __|   |   | |   |  |  __| _ \  _ \
" |\  | |     __ <  |   |  | |    __/  __/
"_| \_|_____|_| \_\____/  _|_|  \___|\___|
"
" NERDTree

inoremap <F9> <ESC>:NERDTreeTabsToggle<CR>
nnoremap <silent> <F9> :NERDTreeTabsToggle<CR>
let g:NERDTreeWinSize=22
let NERDTreeIgnore=['__pycache__', '\.o$', '\.pyc$', '\~$', 'node_modules', '\.dSYM$', '\.class$']

"    \         |
"   _ \    __| |  /
"  ___ \  (      <
"_/    _\\___|_|\_\
"
" ack

cnoreabbrev Ack Ack!
cnoreabbrev ack Ack!
cnoreabbrev Ag Ack!
"nnoremap <Leader>a :Ack!<Space>
nnoremap <Leader>a :Ack!<cword><cr>
noremap <Leader>A :Ack <Space>

"  ___|
"\___ \\ \  \   / _` |  _` |  _` |  _ \  __|
"      |\ \  \ / (   | (   | (   |  __/ |
"_____/  \_/\_/ \__,_|\__, |\__, |\___|_|
"                     |___/ |___/
"
"swagger
nmap <unique> <leader>r <Plug>GenerateDiagram

"  ____|                     \    |_)
"  __|    _` |  __| |   |   _ \   | |  _` | __ \
"  |     (   |\__ \ |   |  ___ \  | | (   | |   |
" _____|\__,_|____/\__, |_/    _\_|_|\__, |_|  _|
"                  ____/             |___/
"
" EasyAlign

vmap <Enter> <Plug>(EasyAlign)


"  ___| |        |  _ \
" |     __|  __| | |   |
" |     |   |    | ___/
"\____|\__|_|   _|_|
"
" CtrlP

" ctags -R
"Ctrl+] - go to definition  -> shift-k //show definition
"Ctrl+T - Jump back from the definition.
"Ctrl+W Ctrl+] - Open the definition in a horizontal split
nmap <Leader>f :CtrlP<CR>
nmap <leader>. :CtrlPTag<CR>
nmap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"__ __|     |
"   |  _` | __ \   __|
"   | (   | |   |\__ \
"  _|\__,_|_.__/ ____/
"
" tabs

nmap <Tab> gt
nmap <S-Tab> gT
nmap <leader>t :tabedit

" ____|                          |
" __|   __ `__ \  __ `__ \   _ \ __|
" |     |   |   | |   |   |  __/ |
"_____|_|  _|  _|_|  _|  _|\___|\__|
"
" emmet

imap <c-j> <esc>:call emmet#moveNextPrev(0)<CR>
imap <c-k> <esc>:call emmet#moveNextPrev(1)<CR>

"  ___|_) |               |   |
" |     | __|  _` | |   | __| __|  _ \  __|
" |   | | |   (   | |   | |   |    __/ |
"\____|_|\__|\__, |\__,_|\__|\__|\___|_|
"            |___/
"
" gitgutter

nmap <Leader>ha :GitGutterStageHunk<CR>
nmap <Leader>hu :GitGutterRevertHunk<CR>
nmap <Leader>hv :GitGutterPreviewHunk<CR>


"  \  |                 _)         _ \                  |
" |\/ |  _ \\ \   / _ \  | __ \   |   | _` | __ \   _ \ |  __|
" |   | (   |\ \ /  __/  | |   |  ___/ (   | |   |  __/ |\__ \
"_|  _|\___/  \_/ \___| _|_|  _| _|   \__,_|_|  _|\___|_|____/
"
" move in panels

nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

" ____|           |       |    _)  _| |
" __|\ \   / _` | |   __| __ \  | |   __|
" |   \ \ / (   | | \__ \ | | | | __| |
"_____|\_/ \__,_|_| ____/_| |_|_|_|  \__|
"
" evil shift!

cab Q q
cab Qa qa
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set
cab Tabnew tabnew

"  ___| |_)       |                         |
" |     | | __ \  __ \   _ \   _` |  __| _` |
" |     | | |   | |   | (   | (   | |   (   |
"\____|_|_| .__/ _.__/ \___/ \__,_|_|  \__,_|
"          _|
"
" integration with system clipboard

map <leader>p "*p
map <leader>y "*y

"     |                                              |      |       ___ \
"     |  _` |\ \   / _` |  __|  _ \  __ `__ \  __ \  |  _ \ __|  _ \   ) |
" \   | (   | \ \ / (   | (    (   | |   |   | |   | |  __/ |    __/  __/
"\___/ \__,_|  \_/ \__,_|\___|\___/ _|  _|  _| .__/ _|\___|\__|\___|_____|
"                                             _|
" javacomplete2

inoremap ,, <C-x><C-o>

"__  /
"   /   _ \   _ \  __ `__ \
"  /   (   | (   | |   |   |
"____|\___/ \___/ _|  _|  _|
"
" zoom toggle

nmap <leader>z :tabnew %<CR>
nmap <leader>Z :q<CR>

"  ___|             | |
"\___ \  __ \   _ \ | |
"     | |   |  __/ | |
"_____/  .__/ \___|_|_|
"       _|
" spell checking

nmap <F2> :set spell! spelllang=en_us <CR>

" __ )             |                                        |
" __ \   _` |  __| __ \    __| |   | __ \  __ \   _ \   __| __|
" |   | (   |\__ \ | | | \__ \ |   | |   | |   | (   | |    |
"____/ \__,_|____/_| |_| ____/\__,_| .__/  .__/ \___/ _|   \__|
"                                   _|    _|
" bash support

autocmd filetype shell nmap <leader>h :!open ~/.vim/bash-support/doc/bash-hot-keys.pdf <CR>

"\ \        /                                |          _)
" \ \  \   / __ `__ \   _` |  __| _` | __ \  __ \\ \   / |_  /
"  \ \  \ /  |   |   | (   | |   (   | |   | | | |\ \ /  |  /
"   \_/\_/  _|  _|  _|\__, |_|  \__,_| .__/ _| |_| \_/  _|___|
"                     |___/           _|
"wmgraphviz

"autocmd bufnewfile *.dot call Headerdot()
function! Headerdot()
   call setline(1,"//usr/bin/dot")
   call append(1,"digraph G{")
   call append(2,"")
   call append(3,"}")
   normal 3G
endfunction

"  ___|                 |          _)
" |      __| _` | __ \  __ \\ \   / |_  /
" |   | |   (   | |   | | | |\ \ /  |  /
"\____|_|  \__,_| .__/ _| |_| \_/  _|___|
"                _|
"
"graphviz

"let g:WMGraphviz_dot = "dot"
"let g:WMGraphviz_output = "png"
"let g:WMGraphviz_viewer = "xdg-open"
"let g:WMGraphviz_shelloptions = ""
nmap <leader>ll :GraphvizCompile <CR>
nmap <leader>lv :GraphvizShow <CR>


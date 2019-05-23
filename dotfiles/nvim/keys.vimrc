" _  _________   __  __  __    _    ____  ____ ___ _   _  ____
"| |/ / ____\ \ / / |  \/  |  / \  |  _ \|  _ \_ _| \ | |/ ___|
"| ' /|  _|  \ V /  | |\/| | / _ \ | |_) | |_) | ||  \| | |  _
"| . \| |___  | |   | |  | |/ ___ \|  __/|  __/| || |\  | |_| |
"|_|\_\_____| |_|   |_|  |_/_/   \_\_|   |_|  |___|_| \_|\____|
"

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


"__ __|                  _)             |
"   |  _ \  __| __ `__ \  | __ \   _` | |
"   |  __/ |    |   |   | | |   | (   | |
"  _|\___|_|   _|  _|  _|_|_|  _|\__,_|_|
"
"terminal

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


"  ___|                      |    _)
"\___ \   _ \ __ `__ \   __| __ \  |
"      |  __/ |   |   |\__ \ | | | |
"_____/ \___|_|  _|  _|____/_| |_|_|
"
" semshi

nnoremap <leader>rn :Semshi rename <space>

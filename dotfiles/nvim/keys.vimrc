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

"  ___| __ \  __ )
" |     |   | __ \
" |   | |   | |   |
"\____|____/ ____/
"
"gdb
"
" <Leader>dd	:GdbStart gdb -q ./a.out	Start debugging session, allows editing the launching command
" <Leader>dl	:GdbStartLLDB lldb ./a.out	Start debugging session, allows editing the launching command
" <Leader>dp	:GdbStartPDB python -m pdb main.py	Start Python debugging session, allows editing the launching command
" <F8>	      :GdbBreakpointToggle	Toggle breakpoint in the coursor line
" <F4>	      :GdbUntil	Continue execution until a given line (until in gdb)
" <F5>	      :GdbContinue	Continue execution (continue in gdb)
" <F10>	      :GdbNext	Step over the next statement (next in gdb)
" <F11>	      :GdbStep	Step into the next statement (step in gdb)
" <F12>	      :GdbFinish	Step out the current frame (finish in gdb)
" <c-p>	      :GdbFrameUp	Navigate one frame up (up in gdb)
" <c-n>	      :GdbFrameDown	Navigate one frame down (down in gdb)


"  _ \  |   | __ \  __ )
" |   | |   | |   | __ \
" ___/  |   | |   | |   |
"_|    \___/ ____/ ____/
"
"pudb

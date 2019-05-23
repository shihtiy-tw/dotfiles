" ____  _    _   _  ____ ___ _   _    ____ ___  _   _ _____ ___ ____
"|  _ \| |  | | | |/ ___|_ _| \ | |  / ___/ _ \| \ | |  ___|_ _/ ___|
"| |_) | |  | | | | |  _ | ||  \| | | |  | | | |  \| | |_   | | |  _
"|  __/| |__| |_| | |_| || || |\  | | |__| |_| | |\  |  _|  | | |_| |
"|_|   |_____\___/ \____|___|_| \_|  \____\___/|_| \_|_|   |___\____|
"

"  ___|                      |    _)
"\___ \   _ \ __ `__ \   __| __ \  |
"      |  __/ |   |   |\__ \ | | | |
"_____/ \___|_|  _|  _|____/_| |_|_|
"
" semshi

function! MyCustomHighlights()
  hi semshiLocal           ctermfg=209 guifg=#ff875f
  hi semshiGlobal          ctermfg=214 guifg=#FFAD69
  hi semshiImported        ctermfg=214 guifg=#FFAD69
  hi semshiParameter       ctermfg=75  guifg=#4CBDD3
  hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
  hi semshiFree            ctermfg=218 guifg=#ffafd7
  hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
  hi semshiAttribute       ctermfg=49  guifg=#89E296
  hi semshiSelf            ctermfg=249 guifg=#b2b2b2
  hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
  "hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
  hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#50a9b1 cterm=underline gui=underline
  hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
  hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
sign define semshiError text=E> texthl=semshiErrorSign
endfunction

autocmd FileType python call MyCustomHighlights()
"autocmd ColorScheme * call MyCustomHighlights()


"  _ \            | |
" |   | |   |  _` | __ \
" ___/  |   | (   | |   |
"_|    \__,_|\__,_|_.__/
"
"pudb

let g:python_host_prog='/usr/bin/python3.6'
let g:python3_host_prog='/usr/bin/python3.6'
" set the virtual env python used to launch the debugger
let g:pudb_python='/usr/bin/python3.6'
" set the entry point (script) to use for pudb
let g:pudb_entry_point='~/src/poweruser_tools/test/test_templates.py'
" Unicode symbols work fine (nvim, iterm, tmux, nyovim tested)
let g:pudb_breakpoint_symbol='*'

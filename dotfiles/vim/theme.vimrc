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


#!/bin/bash

# Check the mode passed by darkman (either "dark" or "light")
MODE=$1

if [ "$MODE" = "dark" ]; then
    tmux source-file ~/dotfiles/tmux/themes/tmux-gruvbox-dark.conf
elif [ "$MODE" = "light" ]; then
    tmux source-file ~/dotfiles/tmux/themes/tmux-gruvbox-light.conf
fi

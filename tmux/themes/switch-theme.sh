#!/bin/bash

# Check the mode passed by darkman (either "dark" or "light")
MODE=$1

if [ "$MODE" = "dark" ]; then
    tmux source-file ~/dotfiles/tmux/themes/tmux-everforest-dark.conf
    tmux source-file ~/dotfiles/tmux/themes/tmux-everforest-dark.conf
elif [ "$MODE" = "light" ]; then
    tmux source-file ~/dotfiles/tmux/themes/tmux-everforest-light.conf
    tmux source-file ~/dotfiles/tmux/themes/tmux-everforest-light.conf
fi

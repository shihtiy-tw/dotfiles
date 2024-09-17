#!/bin/zsh

# Function to change variable values in a file
change_variable_value() {
    local file="$1"
    local variable="$2"
    local value="$3"

    # Check if the file exists
    if [ -f "$file" ]; then
        # Replace the variable value with the new value
        sed -i "s/^$variable=.*/$variable=$value/" "$file"
    else
        echo "File $file does not exist."
    fi
}

# Check if the color-scheme parameter is provided
if [ "$1" = "" ]; then
    echo "Usage: $0 <color-scheme>"
    echo "color-scheme can be 'dark' or 'light'"
    exit 1
fi

# Set the color-scheme based on the provided parameter
color_scheme="$1"

# Set the variable values based on the color-scheme
# tool: tmux, neovim
# mac: iterm, scheme, diable bluelight filter, vscode
if [ "$color_scheme" = "dark" ]; then
    if [ "$OS" = "Mac" ]; then
        sed -i '' "/^export THEME/s/light/dark/g" "$HOME"/dotfiles/zsh/theme.zsh
        # remove comments for gruvbox
        sed -i '' -E 's/^# (set -g @plugin .*gruvbox.*)/\1/' ${HOME}/dotfiles/tmux/tmux.conf
        sed -i '' -E 's/^# (set -g @tmux-gruvbox .*)/\1/' ${HOME}/dotfiles/tmux/tmux.conf
        # add comments for solarized ''
        sed -i '' -E 's/^(set -g @plugin .*solarized.*)/#\ \1/' ${HOME}/dotfiles/tmux/tmux.conf
        sed -i '' -E 's/^(set -g @colors-solarized .*)/#\ \1 /' ${HOME}/dotfiles/tmux/tmux.conf

    else
        sed -i "/^export THEME/s/light/dark/g" "$HOME"/dotfiles/zsh/theme.zsh
        # remove comments for gruvbox
        sed -i.bak --follow-symlinks 's/^# \(set -g @plugin .*gruvbox.*\)/\1/' ~/.tmux.conf
        sed -i.bak --follow-symlinks 's/^# \(set -g @tmux-gruvbox .*\)/\1/' ~/.tmux.conf
        # add comments for solarized
        sed -i.bak --follow-symlinks 's/^\(set -g @plugin .*solarized.*\)/#\ \1/' ~/.tmux.conf
        sed -i.bak --follow-symlinks 's/^\(set -g @colors-solarized .*\)/#\ \1 /' ~/.tmux.conf
    fi

elif [ "$color_scheme" = "light" ]; then
    if [ "$OS" = "Mac" ]; then
        sed -i '' "/^export THEME/s/dark/light/g" "$HOME"/dotfiles/zsh/theme.zsh
        # add comments for gruvbox
        sed -i '' -E 's/^(set -g @plugin .*gruvbox.*)/# \1/' ${HOME}/dotfiles/tmux/tmux.conf
        sed -i '' -E 's/^(set -g @tmux-gruvbox .*)/#\ \1 /' ${HOME}/dotfiles/tmux/tmux.conf
        # remove comments for solari ''zed
        sed -i '' -E 's/^# (set -g @plugin .*solarized.*)/\1/' ${HOME}/dotfiles/tmux/tmux.conf
        sed -i '' -E 's/^# (set -g @colors-solarized .*)/\1/' ${HOME}/dotfiles/tmux/tmux.conf
    else
        sed -i "/^export THEME/s/dark/light/g" "$HOME"/dotfiles/zsh/theme.zsh
        # add comments for gruvbox
        sed -i.bak --follow-symlinks 's/^\(set -g @plugin .*gruvbox.*\)/#\ \1/' ~/.tmux.conf
        sed -i.bak --follow-symlinks 's/^\(set -g @tmux-gruvbox .*\)/#\ \1 /' ~/.tmux.conf
        # remove comments for solarized
        sed -i.bak --follow-symlinks 's/^# \(set -g @plugin .*solarized.*\)/\1/' ~/.tmux.conf
        sed -i.bak --follow-symlinks 's/^# \(set -g @colors-solarized .*\)/\1/' ~/.tmux.conf
    fi
else
    echo "Invalid color-scheme: $color_scheme"
    echo "color-scheme should be 'dark' or 'light'"
    exit 1
fi

rm ${HOME}/dotfiles/tmux/tmux.conf.bak
source "$HOME"/.zshrc

if [ "$OS" = "Mac" ]; then
    if [ ! -d /Applications/ToggleDarkMode.app ]; then
        echo "Follow the doc to create a ToggleDarkMode.app!"
        echo "https://medium.com/@geert.cuppens/macos-keyboard-shortcut-to-toggle-dark-mode-2724c9f7fbfe"
        open "$HOME"/dotfiles/make/mac/ToggleDarkMode.app.scpt
    else
        open /Applications/ToggleDarkMode.app
    fi
fi


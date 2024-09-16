#!/bin/bash

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
if [ "$color_scheme" == "dark" ]; then
    sed -i "/^export THEME/s/light/dark/g" "$HOME"/dotfiles/zsh/theme.zsh
elif [ "$color_scheme" == "light" ]; then
    sed -i "/^export THEME/s/dark/light/g" "$HOME"/dotfiles/zsh/theme.zsh
else
    echo "Invalid color-scheme: $color_scheme"
    echo "color-scheme should be 'dark' or 'light'"
    exit 1
fi

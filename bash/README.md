# Bash Configuration

Configuration files for the Bash shell.

## Structure

- `bashrc` - Main Bash configuration file
- `fish/` - Fish-like theme for Bash

## Features

- Custom prompt
- Useful aliases
- Environment variables
- Shell options
- Command history settings
- Completion configuration

## Installation

The main dotfiles `make init` command will set up the Bash configuration automatically.

For manual installation:
```bash
# Create symlinks
ln -sf ~/dotfiles/bash/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash/bashrc ~/.bash_profile
```

## Customization

You can customize the Bash configuration by editing the `bashrc` file. Some common customizations:

- Add new aliases
- Modify environment variables
- Change prompt appearance
- Add custom functions

## Fish-like Theme

The included Fish-like theme provides a more colorful and informative prompt similar to the Fish shell, while still using Bash. It includes:

- Git branch and status information
- Current directory
- Command execution time
- Return status of previous command

## Resources

- [Bash Documentation](https://www.gnu.org/software/bash/manual/bash.html)
- [Bash Prompt HOWTO](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/)

# ZSH Configuration

This directory contains configuration files for the Z shell (ZSH), providing a powerful and customizable command-line experience.

## Structure

- `zshrc` - Main configuration file (symlinked to `~/.zshrc`)
- `alias.zsh` - Custom aliases for common commands
- `completion.zsh` - ZSH completion settings
- `config.zsh` - General ZSH configuration
- `env.zsh` - Environment variables
- `function.zsh` - Custom shell functions
- `man.zsh` - Colored man pages configuration
- `omzsh.zsh` - Oh-My-ZSH specific settings
- `theme.zsh` - Theme configuration (supports light/dark modes)

## Features

- Integration with Oh-My-ZSH
- Custom prompt with git status information
- Auto-completion enhancements
- Fuzzy finding with FZF
- Autojump for quick directory navigation
- Auto-starting tmux for SSH sessions

## Dependencies

### FZF Installation

```sh
# On macOS
brew install fzf
/usr/local/opt/fzf/install

# On Linux
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Autojump Installation

```sh
# On macOS
brew install autojump

# On Linux
git clone git://github.com/wting/autojump.git
cd autojump
./install.py
```

## Usage Tips

- Use `j [directory]` to quickly jump to frequently used directories
- Press `Ctrl+R` for fuzzy history search
- Use the custom aliases defined in `alias.zsh` for faster workflows

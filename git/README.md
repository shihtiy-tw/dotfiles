# Git Configuration

Custom Git configuration with useful aliases and settings for improved workflow.

## Structure

- `gitconfig` - Main Git configuration file (symlinked to `~/.gitconfig`)

## Features

- Custom aliases for common Git operations
- Color settings for better readability
- Default branch configuration
- Merge and diff tool settings
- Global gitignore settings
- User identity configuration

## Installation

The main dotfiles `make init` command will set up the Git configuration automatically.

For manual installation:
```bash
# Create symlink
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
```

## Usage

After installation, you can use the custom Git aliases defined in the configuration. Some examples:

```bash
# View status
git st

# Add changes
git aa

# Commit changes
git ci

# View log
git lg

# Push to remote
git ps
```

## Customization

Before using this configuration, make sure to update the user section in `gitconfig` with your own information:

```
[user]
    name = Your Name
    email = your.email@example.com
```

You can also customize other settings according to your preferences.

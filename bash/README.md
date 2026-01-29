# Bash Configuration

## Highlights
- **Bash-it Integration**: Uses framework concepts for managing aliases and completions.
- **Cross-Shell Compatibility**: Shares some logic with the Zsh configuration.
- **Modular Design**: Broken down into aliases, functions, and environment variables.

## Structure
- `bashrc`: Main entry point (symlinked to `~/.bashrc`).
- `alias.bash`: Common command shortcuts.
- `functions.bash`: Custom utility functions.
- `bash_it.bash`: Integrations for the Bash-it framework.
- `man.bash`: Colorized man pages.

## Critical Aliases
| Alias | Action |
| :--- | :--- |
| `l` | `ls -lah` (List all with details) |
| `..` | Go up one directory |
| `c` | Clear terminal |

## Installation
The `make init` command in the root Makefile handles symlinking these files to your home directory.

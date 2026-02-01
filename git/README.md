# Git Configuration

## Highlights
- **Diff-so-Fancy**: Human-readable diffs integrated by default.
- **Commit Templates**: Enforces a standard convention via `commit-conventions.txt`.
- **Short Aliases**: Optimized for speed (single-letter commands).

## Structure
- `gitconfig`: The main config (symlinked to `~/.gitconfig`).
- `commit-conventions.txt`: Template for commit messages.
- `diff-so-fancy.sh`: Helper script for better diffs.

## Aliases
| Alias | Command |
| :--- | :--- |
| `g s` | `git status` |
| `g a` | `git add` |
| `g c` | `git commit` |
| `g l` | `git log` (Graph view) |
| `g f` | `git fetch` |
| `g p` | `git pull` |
| `g d` | `git diff` (colorized) |

## Installation
The root `make init` handles the symlinking.
**Note**: The config sets the user to `Shih-Ting, Yuan`. You should override this in your local `~/.gitconfig` if you are not him!

```bash
[user]
    name = Your Name
    email = you@example.com
```

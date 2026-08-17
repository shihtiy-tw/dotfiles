# oh-my-zsh settings. Sourced from zshrc after env.zsh and completion-cache.zsh,
# because oh-my-zsh runs the single compinit for the shell.

ZSH_THEME="spaceship"

# Plugin order is load order, and three of these care about it:
#   - zsh-completions must precede compinit (oh-my-zsh adds plugin dirs to fpath
#     before calling it, so listing it here is enough)
#   - fzf-tab must come after compinit and before anything that wraps ZLE widgets
#   - zsh-syntax-highlighting must be LAST, per its README
# Previously syntax-highlighting sat mid-list with vim-mode, system-clipboard and
# fzf-tab loading after it.
plugins=(
  git
  docker
  aws
  kube-ps1
  autojump
  zsh-completions
  zsh-vim-mode
  zsh-system-clipboard
  zsh-vi-man
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_SYSTEM_CLIPBOARD_METHOD="tmux"

source "$ZSH/oh-my-zsh.sh"

# kube-ps1 has to be prepended *after* oh-my-zsh has loaded the theme: the theme
# assigns PROMPT, so doing this beforehand (as this file used to) was overwritten
# and the kube context never showed up.
if (( $+functions[kube_ps1] )); then
  PROMPT='$(kube_ps1)'$PROMPT
fi

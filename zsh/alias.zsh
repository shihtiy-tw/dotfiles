# Aliases.
#
# autojump is loaded by the oh-my-zsh `autojump` plugin, on both macOS and Linux.
# The three separate hand-rolled sourcings that used to live here and in zshrc
# (one of them pointing at /home/shihtiy/, another user's home) are gone.

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cp="rsync -ah --progress"
alias pingtest="ping 8.8.8.8"
alias c='clear'
alias bkliton='echo 1 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
alias bklitoff='echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias notes='sudo updatedb; locate -r ${HOME}/".*notes_.*\.md"'
alias def='definition'
alias weather='curl wttr.in'
alias sudo='sudo '
alias vbm="VBoxManage"

(( $+commands[nvim] )) && alias vim="nvim"
(( $+commands[tldr] )) && alias tldr='tldr -t ocean'

# `l`: prefer eza (the maintained successor to exa), then exa, then plain ls.
# The old unconditional `exa -lahF` failed with "command not found: exa".
if (( $+commands[eza] )); then
  alias l='eza -lahF'
elif (( $+commands[exa] )); then
  alias l='exa -lahF'
else
  alias l='ls -lAhF'
fi

# kubectl aliases from https://github.com/ahmetb/kubectl-aliases. Completion for
# `k` is wired up with compdef in completion.zsh.
[[ -f "${HOME}/.kubectl_aliases" ]] && source "${HOME}/.kubectl_aliases"

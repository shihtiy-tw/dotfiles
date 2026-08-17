# Completions that cannot be cached as autoloadable fpath functions: they either
# register a bash-style completer at runtime or alias one command's completion to
# another. Sourced after oh-my-zsh, so compinit has already run.
#
# The cacheable ones live in completion-cache.zsh, which runs before compinit.

# kubectl aliases reuse kubectl's own completion. `compdef` is the zsh-native way;
# the old `complete -o default -F __start_kubectl k` ran unconditionally and
# depended on a bash function that only existed if the completion had loaded.
if (( $+commands[kubectl] )); then
  compdef k=kubectl
  (( $+commands[kubecolor] )) && compdef kubecolor=kubectl
fi

# bashcompinit is only needed by the `complete -C` users below. Load it at most once.
_load_bashcompinit() {
  (( $+functions[complete] )) && return 0
  autoload -Uz bashcompinit && bashcompinit
}

if (( $+commands[aws_completer] )); then
  _load_bashcompinit
  complete -C "$commands[aws_completer]" aws
fi

if (( $+commands[terraform] )); then
  _load_bashcompinit
  complete -o nospace -C "$commands[terraform]" terraform
fi

# Guarded on packer, not terraform (the old block tested terraform twice), and
# resolved via $commands instead of a hardcoded /usr/bin path.
if (( $+commands[packer] )); then
  _load_bashcompinit
  complete -o nospace -C "$commands[packer]" packer
fi

# Google Cloud SDK. The old guards were single-quoted, so '${HOME}/...' never
# expanded and neither include was ever sourced; one of them also tested a
# different path than it sourced.
for _gcloud_dir in \
  "${HOME}/google-cloud-sdk" \
  "${HOME}/.google-cloud-sdk" \
  /usr/share/google-cloud-sdk \
  /opt/homebrew/share/google-cloud-sdk
do
  [[ -d $_gcloud_dir ]] || continue
  [[ -f "$_gcloud_dir/path.zsh.inc" ]] && source "$_gcloud_dir/path.zsh.inc"
  [[ -f "$_gcloud_dir/completion.zsh.inc" ]] && source "$_gcloud_dir/completion.zsh.inc"
  break
done
unset _gcloud_dir

# aws-cdk (yargs-based)
if (( $+commands[cdk] )); then
  _cdk_yargs_completions() {
    local reply si=$IFS
    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdk --get-yargs-completions "${words[@]}"))
    IFS=$si
    _describe 'values' reply
  }
  compdef _cdk_yargs_completions cdk
fi

# toggl
if (( $+commands[toggl] )); then
  _toggl() {
    eval $(env COMMANDLINE="${words[1,$CURRENT]}" _TOGGL_COMPLETE=complete-zsh toggl)
  }
  compdef _toggl toggl
fi

# git-flow. Checks for the binary rather than running `git flow version`, which
# cost ~18ms of fork per startup.
# https://github.com/petervanderdoes/git-flow-completion/tree/develop
if (( $+commands[git-flow] )) && [[ -f "$DOTFILES/git/git-flow-completion.zsh" ]]; then
  source "$DOTFILES/git/git-flow-completion.zsh"
fi

# bun
[[ -s "${BUN_INSTALL:-$HOME/.bun}/_bun" ]] && source "${BUN_INSTALL:-$HOME/.bun}/_bun"

# ssh/scp host completion from ssh config and known_hosts. Read with $(<file)
# rather than $(cat file) to avoid the forks.
() {
  local -a hosts
  if [[ -r ~/.ssh/config ]]; then
    hosts+=(${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
  fi
  local known
  for known in ~/.ssh/known_hosts ~/.ssh/known_hosts2; do
    [[ -r $known ]] || continue
    hosts+=(${${${(f)"$(<$known)"}%%\ *}%%,*})
  done
  if (( $#hosts )); then
    zstyle ':completion:*:ssh:*'   hosts $hosts
    zstyle ':completion:*:scp:*'   hosts $hosts
    zstyle ':completion:*:slogin:*' hosts $hosts
  fi
}

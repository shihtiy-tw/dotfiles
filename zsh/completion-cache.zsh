# Completion functions generated once into $ZSH_COMPCACHE, instead of running
# `source <(tool completion zsh)` on every startup - that was ~123ms of forks
# per shell (kubectl 49ms, helm 28ms, eksctl 23ms, gh 23ms).
#
# Each of these generators prints a script whose first line is `#compdef <tool>`,
# so the output is directly autoloadable from fpath. Sourced before oh-my-zsh so
# the files exist by the time compinit builds its dump.

typeset -g _compcache_changed=0

# _compcache_gen <function-name> <command...>
# The first word of <command...> is the binary that must exist, and whose mtime
# decides whether the cache is stale.
_compcache_gen() {
  local name=$1
  shift
  local tool=$1
  (( $+commands[$tool] )) || return 0

  local out="$ZSH_COMPCACHE/_$name"
  # Up to date when the cache exists and is newer than the binary.
  [[ -s $out && $out -nt $commands[$tool] ]] && return 0

  if "$@" >| "$out.new" 2>/dev/null && [[ -s $out.new ]]; then
    command mv -f "$out.new" "$out"
    _compcache_changed=1
  else
    command rm -f "$out.new"
  fi
}

_compcache_gen kubectl  kubectl completion zsh
_compcache_gen helm     helm completion zsh
_compcache_gen eksctl   eksctl completion zsh
_compcache_gen gh       gh completion -s zsh
_compcache_gen minikube minikube completion zsh
_compcache_gen k3s      k3s completion zsh
_compcache_gen awless   awless completion zsh

# A newly written completion function will not be visible until compinit rebuilds
# its dump, so drop the dumps when something changed. This is rare - only after a
# tool is installed or upgraded.
if (( _compcache_changed )); then
  # oh-my-zsh writes its dump next to .zshrc, which is $ZDOTDIR when that is set.
  command rm -f "${ZDOTDIR:-$HOME}"/.zcompdump*(N) 2>/dev/null
fi

unset _compcache_changed
unfunction _compcache_gen

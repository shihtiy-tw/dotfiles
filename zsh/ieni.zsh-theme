# vim:ft=zsh ts=2 sw=2 sts=2

rvm_current() {
  rvm current 2>/dev/null
}

rbenv_version() {
  rbenv version 2>/dev/null | awk '{print $1}'
}

_fishy_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

#PROMPT='%n@%m %{$fg_bold[$user_color]%}%{$fg_bold[green]%}$(_fishy_collapsed_wd)%{$reset_color%} %(!.#.>) $(git_prompt_info)
PROMPT='
%{$fg_bold[yellow]%}%n %{$fg_bold[white]%}in %{$fg_bold[$user_color]%}%{$fg_bold[green]%}$(_fishy_collapsed_wd) %{$fg_bold[white]%}at %{$fg_bold[blue]%}%m%{$reset_color%} %(!.#.>) $(git_prompt_info)
$ '


#PROMPT='
#%n@%m %{$fg[$user_color]%}%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)
#$ '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#if [ -e ~/.rvm/bin/rvm-prompt ]; then
  #RPROMPT='%{$fg_bold[red]%}‹$(rvm_current)›%{$reset_color%}'
#else
  #if which rbenv &> /dev/null; then
    #RPROMPT='%{$fg_bold[red]%}$(rbenv_version)%{$reset_color%}'
  #fi
#fi

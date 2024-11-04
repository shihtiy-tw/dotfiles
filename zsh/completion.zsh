# awless
if [ -f "$(which awless)" ]; then source <(awless completion zsh); fi

# kubectl
if [ -f "$(which kubectl)" ]; then source <(kubectl completion zsh); fi
if [ -f "$(which kubecolor)" ]; then compdef kubecolor=kubectl; fi

# minikube
if [ -f "$(which minikube)" ]; then source <(minikube completion zsh); fi

# k3s
if [ -f "$(which k3s)" ]; then source <(k3s completion zsh); fi

# helm
if [ -f "$(which helm)" ]; then source <(helm completion zsh); fi

# eksctl
if [ -f "$(which eksctl)" ]; then source <(eksctl completion zsh); fi

# aws
if [ -f "$(which aws)" ]; then
  autoload bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
  complete -C '/usr/local/bin/aws_completer' aws
fi

# github cli
if [ -f "$(which gh)" ]; then source <(gh completion -s zsh); fi

# git flow
# https://github.com/petervanderdoes/git-flow-completion/tree/develop
if git flow version >> /dev/null; then source ~/dotfiles/git/git-flow-completion.zsh; fi

#compdef toggl
if [[ -f "$(which toggl)" ]]; then
  _toggl() {
    eval $(env COMMANDLINE="${words[1,$CURRENT]}" _TOGGL_COMPLETE=complete-zsh  toggl)
  }
  if [[ "$(basename -- ${(%):-%x})" != "_toggl" ]]; then
    compdef _toggl toggl
  fi
fi

# terraform
if [ -f "$(which terraform)" ]; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/bin/terraform terraform
fi

# packer
if [ -f "$(which terraform)" ]; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/bin/packer packer
fi

#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://github.com/zsh-users/antigen/issues/603
# source /usr/local/share/zsh/site-functions/_awless

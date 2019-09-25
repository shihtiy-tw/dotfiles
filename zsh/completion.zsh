# awless
if [ -f "$(which awless)" ]; then source <(awless completion zsh); fi

# kubectl
if [ -f "$(which kubectl)" ]; then source <(kubectl completion zsh); fi

# minikube
if [ -f "$(which minikube)" ]; then source <(minikube completion zsh); fi

# helm
if [ -f "$(which helm)" ]; then source <(helm completion zsh); fi

#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# https://github.com/zsh-users/antigen/issues/603
# source /usr/local/share/zsh/site-functions/_awless

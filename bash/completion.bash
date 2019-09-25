# awless
if [ -f "$(which awless)" ]; then source <(awless completion bash); fi

# kubectl
if [ -f "$(which kubectl)" ]; then source <(kubectl completion bash); fi

# minikube
if [ -f "$(which minikube)" ]; then source <(minikube completion bash); fi

# helm
if [ -f "$(which helm)" ]; then source <(helm completion bash); fi



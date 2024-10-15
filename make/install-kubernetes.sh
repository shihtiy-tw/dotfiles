# Kubernetes

# kubectl
# https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/darwin/amd64/kubectl
chmod +x ./kubectl
mkdir -p "$HOME"/bin && cp ./kubectl "$HOME"/bin/kubectl

# eksctl
# https://eksctl.io/installation/
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "$PLATFORM" | sha256sum --check

tar -xzf eksctl_"$PLATFORM".tar.gz -C /tmp && rm eksctl_"$PLATFORM".tar.gz

sudo mv /tmp/eksctl /usr/local/bin

# helm
# https://helm.sh/docs/intro/install/#from-apt-debianubuntu
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# krew: plugin manager
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"$KREW" install krew
)

# plugins
kubectl krew install fuzzy
kubectl krew install ctx
kubectl krew install ns

# kubectl fzf
# FIX: confirm why fzf not working with resources
go install github.com/bonnefoa/kubectl-fzf/v3/cmd/kubectl-fzf-completion@main

# k9s
curl -sS https://webinstall.dev/k9s | bash

# kube-alias
curl -o "$HOME"/.kubectl_aliases https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases

# kustomize
# https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

# kubecolor
go install github.com/kubecolor/kubecolor@latest

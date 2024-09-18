#!/bin/bash
set -x 
echo starting...
mkdir -p /etc/peak-scale/

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

# Install ArgoCD
## Client
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

## Server
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd --version 7.5.2 --create-namespace -f /root/.assets/argo.values.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Create ServiceAccount Kubeconfig
kubectl apply -f /root/.assets/serviceaccount.yaml
bash /root/.assets/create_kubeconfig.sh admin-sa kube-system /etc/peak-scale/kubeconfig

touch /tmp/finished
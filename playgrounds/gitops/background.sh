#!/bin/bash
set -x 
echo starting...

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
helm install my-argo-cd argo/argo-cd --version 7.5.2 --set server.extraArgs={--insecure} --set=configs.secret.argocdServerAdminPassword="$2a$12$wtoTp15Kdrq1K8UKwhjITuuDMyQJoaPnT6edBlxjxWaVw6S9Ydq9G"

# Install Fluxcd

touch /tmp/finished
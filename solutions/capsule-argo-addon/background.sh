#!/bin/bash
set -x 
echo starting...
mkdir -p /etc/peak-scale/

# Install argo Client
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

touch /tmp/finished
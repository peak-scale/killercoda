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

curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Create ServiceAccount Kubeconfig
kubectl apply -f /root/.assets/serviceaccount.yaml
bash /root/.assets/create_kubeconfig.sh admin-sa kube-system /etc/peak-scale/kubeconfig
touch /tmp/finished
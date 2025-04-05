#!/bin/bash
set -x 
echo starting...

# OIDC Client
OIDC_CLIENT="demo"
OIDC_SECRET="demo"

# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Install Plugins
kubectl krew install oidc-login

# Install OpenTofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm -f install-opentofu.sh

# Install Flux
curl -s https://fluxcd.io/install.sh | sudo bash

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -


touch /tmp/finished
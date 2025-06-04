#!/bin/bash
set -x 
echo starting...
sudo apt install gnupg2 age

# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

SOPS=/usr/local/bin/sops
SOPS_VERSION=3.9.4
SOPS_LOOKUP=getsops/sops
curl -LO "https://github.com/${SOPS_LOOKUP}/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64"
mv "sops-v${SOPS_VERSION}.linux.amd64" "${SOPS}"
chmod +x "${SOPS}"

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -

touch /tmp/finished
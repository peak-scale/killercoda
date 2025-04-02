#!/bin/bash
set -x 
echo starting...

# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Install Flux
curl -s https://fluxcd.io/install.sh | sudo bash

# Trivy CLI
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.47.0

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -

# Create Kubeconfigs
touch /tmp/finished

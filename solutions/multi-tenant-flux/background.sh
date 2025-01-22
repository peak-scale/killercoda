#!/bin/bash
set -x 
echo starting...
mkdir -p /etc/peak-scale/
touch -p /etc/peak-scale/setup-log

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Stuff
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -


touch /tmp/finished
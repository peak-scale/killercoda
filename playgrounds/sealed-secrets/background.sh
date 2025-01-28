#!/bin/bash
set -x 
echo starting...
mkdir -p /etc/peak-scale/
touch -p /etc/peak-scale/setup-log

# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash

KUBESEAL_VERSION='0.28.0' # Set this to, for example, KUBESEAL_VERSION='0.23.0'
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -

# Restart Controller to load new sealing key-pair
kubectl -n sealed-secrets delete pod -l name=sealed-secrets-controller

# Patch Web Context
WEBUI=$(sed 's/PORT/30080/g' /etc/killercoda/host)
kubectl patch deployment sealed-secrets-web -n sealed-secrets \
  --type=json \
  -p "[{\"op\":\"add\",\"path\":\"/spec/template/spec/containers/0/args/-\",\"value\":\"${WEBUI}/\"}]"


touch /tmp/finished
#!/bin/bash
set -x 
echo starting...
mkdir -p /etc/peak-scale/
touch -p /etc/peak-scale/setup-log


# Function to get all HelmReleases
get_helm_releases() {
  kubectl get helmreleases -A -o json | jq -c '.items[]'
}

# Function to check observedGeneration for a HelmRelease
check_observed_generation() {
  local namespace="$1"
  local name="$2"

  # Get observedGeneration
  observed_generation=$(kubectl get helmrelease "$name" -n "$namespace" -o jsonpath='{.status.observedGeneration}' 2>/dev/null)
  
  # If observedGeneration is null or 0, return 1 (not ready)
  if [[ -z "$observed_generation" || "$observed_generation" -eq 0 ]]; then
    return 1
  fi

  # Return 0 if observedGeneration is greater than 0
  return 0
}

# Install argo Client
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Install Fluxcd
curl -s https://fluxcd.io/install.sh | sudo bash
flux install

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Wait until distro ready
for helmrelease in $(get_helm_releases); do
  # Extract namespace and name
  namespace=$(echo "$helmrelease" | jq -r '.metadata.namespace')
  name=$(echo "$helmrelease" | jq -r '.metadata.name')

  echo "Checking HelmRelease '$name' in namespace '$namespace'..." >> /etc/peak-scale/setup-log

  # Loop until observedGeneration is greater than 0
  while ! check_observed_generation "$namespace" "$name"; do
    echo "Waiting for HelmRelease '$name' in namespace '$namespace' to reach an observedGeneration > 0..." >> /etc/peak-scale/setup-log
    sleep 5
  done

  echo "HelmRelease '$name' in namespace '$namespace' has observedGeneration > 0." >> /etc/peak-scale/setup-log

done

# Apply Stuff
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -


touch /tmp/finished
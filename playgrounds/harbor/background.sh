#!/bin/bash
set -x 
echo starting...

# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Create Required Configmap
export WEBUI=$(sed 's/PORT/30080/g' /etc/killercoda/host)
COMMONNAME=$(echo "$WEBUI" | sed -E 's#https?://##')
cat <<EOF | envsubst | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: harbor-values
  namespace: flux-system
data:
  values.yaml: |
    externalURL: "${WEBUI}"
    expose:
      tls:
        auto:
          commonName: "${COMMONNAME}"
EOF


# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Install OpenTofu
snap install opentofu --classic

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

touch /tmp/finished
#!/bin/bash
set -x 
echo starting...
sudo apt install gnupg2 age

# Move Directories
mv /root/.assets/example/gpg/ /root/gpg

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

mkdir ./bao
BAO='/usr/bin/bao'
BAO_VERSION='2.1.1'
BAO_LOOKUP='openbao/openbao'
curl -LO "https://github.com/${BAO_LOOKUP}/releases/download/v${BAO_VERSION}/bao_${BAO_VERSION}_linux_amd64.pkg.tar.zst"
tar --zstd -xvf "bao_${BAO_VERSION}_linux_amd64.pkg.tar.zst" -C ./bao
mv ./bao/usr/bin/bao "${BAO}"
chmod +x "${BAO}"
rm -rf ./bao

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -

kubectl create ns solar-prod --as alice --as-group projectcapsule.dev
kubectl create ns solar-test --as alice --as-group projectcapsule.dev
kubectl create ns solar-dev --as alice --as-group projectcapsule.dev

touch /tmp/finished
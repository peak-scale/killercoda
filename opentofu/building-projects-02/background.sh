#!/bin/bash
set -x 
echo starting...
mkdir ~/solutions

# Install Opentofu
snap install opentofu --classic

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

# -- Install Minio (Test)


# -- Install Minio (Prod)


touch /tmp/finished

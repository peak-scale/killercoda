#!/bin/bash
set -x 
echo starting...

# OIDC Client
OIDC_CLIENT="capsule"
OIDC_SECRET="capsule"


#oidc-setup/%: kubectl-oidc
#	kubectl oidc-login setup \
#		--username=$* \
#		--password=$* \
#		--oidc-issuer-url=https://sso-test.buttah.cloud/realms/demo \
#		--oidc-client-id=kubernetes \
#		--oidc-client-secret="NGNn51nggoVJFLZ6tas1GffrD1cnbRx0"



# Install Flux
kubectl kustomize /root/.assets/flux/ | kubectl apply -f -

# Install Distribution
kubectl kustomize /root/.assets/distro/ | kubectl apply -f -

# Install Plugins
kubectl krew install oidc-login

# Install OpenTofu
snap install opentofu --classic

# Install Flux
curl -s https://fluxcd.io/install.sh | sudo bash

# Verify Distribution
while [ "$(kubectl get helmrelease -A -o jsonpath='{range .items[?(@.status.observedGeneration<0)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | wc -l)" -ne 0 ]; do
  echo "Waiting for all HelmReleases to have observedGeneration >= 0..." >> /etc/peak-scale/setup-log
  sleep 5
done

# Apply Objects
kubectl kustomize /root/.assets/objects/ | kubectl apply -f -


# Create Kubeconfigs
mkdir /root/.kubconfigs && cd /root/.kubconfigs 
curl -s https://raw.githubusercontent.com/projectcapsule/capsule/main/hack/create-user.sh | bash -s -- alice oil projectcapsule.dev,capsule.clastix.io
mv alice-oil.kubeconfig alice.kubeconfig
KUBECONFIG=alice.kubeconfig kubectl config set clusters.kind-capsule.certificate-authority-data $$(cat $(ROOTCA) | base64 |tr -d '\n')
KUBECONFIG=alice.kubeconfig kubectl config set clusters.kind-capsule.server https://127.0.0.1:9001

curl -s https://raw.githubusercontent.com/projectcapsule/capsule/main/hack/create-user.sh | bash -s -- bob gas projectcapsule.dev,capsule.clastix.io
mv bob-gas.kubeconfig bob.kubeconfig
KUBECONFIG=bob.kubeconfig kubectl config set clusters.kind-capsule.certificate-authority-data $$(cat $(ROOTCA) | base64 |tr -d '\n')
KUBECONFIG=bob.kubeconfig kubectl config set clusters.kind-capsule.server https://127.0.0.1:9001

curl -s https://raw.githubusercontent.com/projectcapsule/capsule/main/hack/create-user.sh | bash -s -- joe gas projectcapsule.dev,capsule.clastix.io,foo.clastix.io
mv joe-gas.kubeconfig foo.clastix.io.kubeconfig
KUBECONFIG=foo.clastix.io.kubeconfig kubectl config set clusters.kind-capsule.certificate-authority-data $$(cat $(ROOTCA) | base64 |tr -d '\n')
KUBECONFIG=foo.clastix.io.kubeconfig kubectl config set clusters.kind-capsule.server https://127.0.0.1:9001

touch /tmp/finished
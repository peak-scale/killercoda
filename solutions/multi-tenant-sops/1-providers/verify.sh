#!/bin/bash

kubectl create -f - <<EOF
apiVersion: addons.projectcapsule.dev/v1alpha1
kind: SopsProvider
metadata:
  name: system-provider
spec:
  keys:
  - namespaceSelector:
      matchExpressions:
       - { key: capsule.clastix.io/tenant, operator: NotExists }
  sops:
  - namespaceSelector:
      matchExpressions:
       - { key: capsule.clastix.io/tenant, operator: NotExists }
EOF

kubectl create -f - <<EOF
apiVersion: addons.projectcapsule.dev/v1alpha1
kind: SopsProvider
metadata:
  name: solar-provider
spec:
  keys:
  - namespaceSelector:
      matchLabels:
        capsule.clastix.io/tenant: solar
  sops:
  - namespaceSelector:
      matchLabels:
        capsule.clastix.io/tenant: solar
EOF

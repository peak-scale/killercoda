#!/bin/bash

# Add Solution for review
mkdir -p ~/.solutions/step2 || true
cat << 'EOF' > ~/.solutions/step2/provider.tf
#!/bin/bash
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
EOF

diff -w  -sB ~/.solutions/step2/provider.tf ~/infrastructure/provider.tf
if [ $? -ne 0 ]; then
  exit 1
fi
#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step2"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/provider.tf"
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

# Verify the Solution
diff -w -B <(hcl2json ~/scenario/provider.tf) <(hcl2json ${SOLUTION_DIR}/provider.tf)
if [ $? -ne 0 ]; then
  exit 1
fi
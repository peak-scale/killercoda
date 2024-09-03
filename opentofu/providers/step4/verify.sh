#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true


# Create provider.tf file
cat <<EOF > "${SOLUTION_DIR}/provider.tf"
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

provider "kubernetes" {
  alias = "k8s"
  config_path = "~/.kube/config"
  ignore_annotations = [
    "cni\\\\.projectcalico\\\\.org\\\\/*"
  ]
}
EOF


# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/pod.tf"
resource "kubernetes_pod_v1" "workload" {
  provider = kubernetes.k8s
  metadata {
    name = "dev-pod"
    namespace = "dev-environment"
  }
  
  spec {
    service_account_name = "dev-sa"
    container {
      image = "nginx:latest"
      name  = "nginx"
      port {
        container_port = 80
      }
    }
  }
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/pod.tf | jq '
  .resource.kubernetes_pod_v1 | 
  to_entries | 
  .[0].value[0] as $item | 
  (
    $item.provider == "${kubernetes.k8s}"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

result=$(hcl2json ~/scenario/provider.tf | jq '
  any(.provider.kubernetes[]; .alias == "k8s")
')
if [ "$result" = "false" ]; then
  exit 1
fi

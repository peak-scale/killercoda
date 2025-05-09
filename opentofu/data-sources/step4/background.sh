#!/bin/bash

cat <<EOF > ~/scenario/outputs.tf
output "pod_uids" {
  value = [for pod in data.kubernetes_pod.workload_info : ... ]
}
EOF

cat <<EOF > ~/scenario/locals.tf
locals {
  replicas = 3
}
EOF

# Add Solution for review
cat << 'EOF' > ~/scenario/pods-count.tf
resource "kubernetes_pod_v1" "count-workload" {
  count = local.replicas

  metadata {
    name = "nginx-count-${count.index}"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
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

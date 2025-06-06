#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/pods-count.tf"
resource "kubernetes_pod_v1" "deployment" {
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

cat << 'EOF' > "${SOLUTION_DIR}/locals.tf"
locals {
  replicas = 5
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/pods-count.tf | jq '
  .resource.kubernetes_pod_v1 | 
  to_entries | 
  .[0].value[0] as $pod | 
  (
    $pod.metadata[0].name == "nginx-count-${count.index}"
  ) and (
    $pod.count == "${local.replicas}"
  )
')
if [[ -z "$result" || "$result" = "false" ]]; then
  exit 1
fi

if ! [[ "$(kubectl get pod -n dev-environment | grep nginx-count- | wc -l)" -ge 5 ]]; then
  exit 1
fi

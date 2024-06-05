#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step3"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/pod.tf"
resource "kubernetes_pod_v1" "workload" {
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

cat << 'EOF' > "${SOLUTION_DIR}/serviceaccount.tf"
resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "dev-sa"
    namespace = "dev-environment"
  }
}
EOF

cat << 'EOF' > "${SOLUTION_DIR}/namespace.tf"
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "dev-environment"
  }
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/namespace.tf | jq '
  .resource.kubernetes_namespace_v1 | 
  to_entries | 
  .[0].value[0] as $item | 
  (
    $item.metadata[0].name == "dev-environment"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

result=$(hcl2json ~/scenario/serviceaccount.tf | jq '
  .resource.kubernetes_serviceaccount_v1 | 
  to_entries | 
  .[0].value[0] as $item | 
  (
    $item.metadata[0].name == "dev-sa"
  ) and (
    $item.metadata[0].namespace == "dev-environment"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

result=$(hcl2json ~/scenario/pod.tf | jq '
  .resource.kubernetes_pod_v1 | 
  to_entries | 
  .[0].value[0] as $item | 
  (
    $item.metadata[0].name == "dev-pod"
  ) and (
    $item.metadata[0].namespace == "dev-environment"
  ) and (
    $item.spec[0].service_account_name == "dev-sa"
  ) and (
    $item.spec[0].container[0].image == "nginx:latest"
  ) and (
    $item.spec[0].container[0].name == "nginx"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

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
diff <(hcl2json ~/scenario/namespace.tf) <(hcl2json ${SOLUTION_DIR}/namespace.tf)
if [ $? -ne 0 ]; then
  exit 1
fi

diff <(hcl2json ~/scenario/serviceaccount.tf) <(hcl2json ${SOLUTION_DIR}/serviceaccount.tf)
if [ $? -ne 0 ]; then
  exit 1
fi

diff <(hcl2json ~/scenario/pod.tf) <(hcl2json ${SOLUTION_DIR}/pod.tf)
if [ $? -ne 0 ]; then
  exit 1
fi


#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step3"
mkdir -p "${SOLUTION_DIR}" || true

cat << 'EOF' > "${SOLUTION_DIR}/sources.tf"
data "kubernetes_namespace_v1" "namespace" {
  provider = kubernetes.k8s
  metadata {
    name = "prod-environment"
  }
}

data "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    namespace = kubernetes_service_account_v1.serviceaccount.metadata.0.namespace
  }
}

data "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    name = kubernetes_secret_v1.serviceaccount_token.metadata.0.name
    namespace = kubernetes_secret_v1.serviceaccount_token.metadata.0.namespace
  }
}

data "kubernetes_pod_v1" "workload" {
  metadata {
    name = kubernetes_pod_v1.workload.metadata.0.name
    namespace = kubernetes_pod_v1.workload.metadata.0.namespace
  }

  lifecycle {
    postcondition {
      condition     = self.status == "Running"
      error_message = "Pod is not in the Running phase."
    }
  }
}
EOF

# Verify the Solution
diff <(hcl2json ~/scenario/sources.tf | jq '.data.kubernetes_namespace_v1.namespace[0].provider') <(hcl2json ${SOLUTION_DIR}/sources.tf | jq '.data.kubernetes_namespace_v1.namespace[0].provider')
if [ $? -ne 0 ]; then
  exit 1
fi

diff <(hcl2json hcl2json ~/scenario/sources.tf | jq '.data.kubernetes_pod_v1.workload[0].lifecycle[0]') <(hcl2json ${SOLUTION_DIR}/sources.tf | jq '.data.kubernetes_pod_v1.workload[0].lifecycle[0]')
if [ $? -ne 0 ]; then
  exit 1
fi
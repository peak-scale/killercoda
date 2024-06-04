#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step1"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << EOF > "${SOLUTION_DIR}/sources.tf"
data "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = kubernetes_namespace_v1.namespace.metadata.0.name
  }
}

data "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }
}

data "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    name = kubernetes_secret_v1.serviceaccount_token.metadata.0.name
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }
}

data "kubernetes_pod_v1" "workload" {
  metadata {
    name = kubernetes_pod_v1.workload.metadata.0.name
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }
}
EOF

cat << EOF > "${SOLUTION_DIR}/outputs.tf"
output "namespace" {
  value = data.kubernetes_namespace_v1.namespace
}

output "service_account" {
  value = data.kubernetes_service_account_v1.serviceaccount
}

output "secret" {
  sensitive = true
  value = data.kubernetes_secret_v1.serviceaccount_token
}

output "pod" {
  value = data.kubernetes_pod_v1.workload
}
EOF

# Verify the Solution
diff <(hcl2json ~/scenario/outputs.tf) <(hcl2json "${SOLUTION_DIR}/outputs.tf")
if [ $? -ne 0 ]; then
  exit 1
fi

diff <(hcl2json ~/scenario/sources.tf) <(hcl2json "${SOLUTION_DIR}/sources.tf")
if [ $? -ne 0 ]; then
  exit 1
fi

cd ~/scenario
if [ $(tofu state ls | grep "data.kubernetes_" | wc -l) -ne 4 ]; then
  exit 1
fi

#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/count-sources.tf"
data "kubernetes_pod" "workload_info" {
  count = local.replicas

  metadata {
    name      = kubernetes_pod_v1.count-workload[count.index].metadata[0].name
    namespace = kubernetes_pod_v1.count-workload[count.index].metadata[0].namespace
  }

  depends_on = [kubernetes_pod_v1.count-workload]
}
EOF


# Add Solution for review
cat << 'EOF' >> "${SOLUTION_DIR}/outputs.tf"
output "pod_uids" {
  value = [for pod in data.kubernetes_pod.workload_info : pod.metadata[0].uid]
}
EOF

diff <(hcl2json ~/scenario/outputs.tf | jq '.output.pod_uids[0].value') <(hcl2json "${SOLUTION_DIR}/outputs.tf" | jq '.output.pod_uids[0].value')
if [ $? -ne 0 ]; then
  exit 1
fi

# Verify the Solution
result=$(hcl2json ~/scenario/count-sources.tf | jq '.data.kubernetes_pod.workload_info[] | 
  (
    .metadata[0].name == "${kubernetes_pod_v1.count-workload[count.index].metadata[0].name}"
  ) and (
    .count == "${local.replicas}"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

if ! [ $(kubectl get pod -n prod-environment | grep nginx-count- | wc -l) -ge 5 ]; then
  exit 1
fi
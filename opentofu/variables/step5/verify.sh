#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step5"
mkdir -p "${SOLUTION_DIR}" || true

# Post Solution
cat << 'EOF' > "${SOLUTION_DIR}/outputs.tf"
output "pod_name" {
  description = "The name of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].name
}

output "pod_uid" {
  description = "The UID of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].uid
}
EOF

# Verify
cd ~/scenario
if [[ "$(tofu output -json | jq -r '.|.pod_name.value')" != "nginx" ]]; then
  exit 1
fi

if [[ "$(tofu output -json | jq -r '.|.pod_uid.type')" != "string" ]]; then
  exit 1
fi

exit 0 
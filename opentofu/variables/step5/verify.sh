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
# cd "${HOME}/scenario"
# 
# output=$(tofu output -json)
# if [ $? -ne 0 ]; then
#   echo "Failed to get output from tofu"
#   exit 1
# fi
# 
# pod_name=$(echo "$output" | jq -r '.pod_name.value')
# if [ "$pod_name" != "nginx" ]; then
#   exit 1
# fi
# 
# pod_uid_sensitive=$(echo "$output" | jq -r '.pod_uid.type')
# if [ "$pod_uid_sensitive" != "string" ]; then
#   exit 1
# fi
# exit 0 
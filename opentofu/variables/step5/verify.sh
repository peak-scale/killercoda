#!/bin/bash

# Post Solution
mkdir -p ~/.solutions/step5 || true
cat << 'EOF' > ~/.solutions/step5/outputs.tf
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
if [ "$(tofu output -json | jq -r '.|.pod_name.value')" != "nginx" ]; then
  exit 1
fi

if [ "$(tofu output -json | jq -r '.|.pod_uid.type')" != "string" ]; then
  exit 1
fi
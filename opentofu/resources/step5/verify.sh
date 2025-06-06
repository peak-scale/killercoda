#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step5"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/pods-foreach.tf"
locals {
  workloads = [
    {
      name  = "busybox"
      image = "busybox:latest"
    },
    {
      name  = "alpine"
      image = "alpine:latest"
    },
    {
      name  = "bash"
      image = "bash:latest"
    }
  ]
}

resource "kubernetes_pod_v1" "for-workload" {
  for_each = { for idx, workload in local.workloads : idx => workload }

  metadata {
    name = each.value.name
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    container {
      image = each.value.image
      name  = each.value.name
    }
  }

  lifecycle {
    ignore_changes = [
        metadata[0].annotations["cni.projectcalico.org/containerID"],
        metadata[0].annotations["cni.projectcalico.org/podIP"],
        metadata[0].annotations["cni.projectcalico.org/podIPs"]
    ]
  }
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/pods-foreach.tf | jq '.resource.kubernetes_pod_v1."for-workload"[] |
  (
    .metadata[0].name == "${each.value.name}"
  ) and (
    .for_each == "${{ for idx, workload in local.workloads : idx =\u003e workload }}"
  ) and (
    .spec[0].container[0].name == "${each.value.name}"
  ) and (
    .spec[0].container[0].image == "${each.value.image}"
  )')
if [[ -z "$result" || "$result" != "true" ]]; then
  exit 1
fi

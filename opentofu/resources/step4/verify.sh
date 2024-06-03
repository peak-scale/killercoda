#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/pods-count.tf"
resource "kubernetes_pod_v1" "workload" {
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
result=$(hcl2json ~/scenario/pod-count.tf | jq '
  .resource.kubernetes_pod_v1 | 
  to_entries | 
  .[0].value[0] as $pod | 
  (
    $pod.metadata[0].name == "nginx-count-${count.index}"
  ) and (
    $pod.count == "${local.replicas}"
  )
')
if [ "$result" = "false" ]; then
  exit 1
fi

if ! [ $(kubectl get pod -n prod-environment | grep nginx-count- | wc -l) -ge 5 ]; then
  exit 1
fi
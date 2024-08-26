output "pod_name" {
  description = "The name of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].name
}

output "pod_uid" {
  description = "The UID of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].uid
}
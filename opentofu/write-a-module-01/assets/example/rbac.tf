resource "kubernetes_cluster_role" "read_only" {
  metadata {
    name = "read-only"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "deployments", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "owner" {
  metadata {
    name = "owner"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "administrator" {
  metadata {
    name = "administrator"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
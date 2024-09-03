resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_resource_quota" "quota" {
  metadata {
    name      = "${var.tenant_name}-quota"
    namespace = var.namespace_name
  }

  spec {
    hard = var.quota
  }

  depends_on = [kubernetes_namespace.namespace]  
}

resource "kubernetes_role_binding" "rolebinding" {
  for_each = {
    for perm in var.permissions : 
    "${perm.name}-${perm.role}-${var.namespace_name}" => {
      name      = perm.name
      kind      = perm.kind
      role      = perm.role
      namespace = var.namespace_name
    }
  }

  metadata {
    name      = "${each.value.name}-${each.value.role}-binding"
    namespace = var.namespace_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value.role
  }

  subject {
    kind      = each.value.kind
    name      = each.value.name
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [kubernetes_namespace.namespace]  
}

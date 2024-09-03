module "namespace" {
  for_each = toset(var.namespaces)

  source = "./modules/namespace"

  tenant_name     = var.tenant_name
  namespace_name  = "${var.tenant_name}-${each.value}"
  quota           = var.quota
  permissions     = var.permissions
}
locals {
  tenant_files = fileset(".", "${path.module}/tenants/*.yaml")
  tenants = { for f in local.tenant_files : yamldecode(file(f)).name => yamldecode(file(f)) }
}

module "tenants" {
  source = "./modules/tenant"

  for_each = local.tenants

  tenant_name  = each.value.name
  namespaces   = each.value.namespaces
  quota        = each.value.quota
  permissions  = each.value.permissions
}

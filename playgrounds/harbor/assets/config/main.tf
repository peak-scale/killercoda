provider "harbor" {
  url      = var.harbor_url
  username = var.harbor_admin_username
  password = var.harbor_admin_password
  insecure = var.harbor_insecure
}

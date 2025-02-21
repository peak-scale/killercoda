resource "harbor_user" "alice" {
  username = "alice"
  password = "alicealice"
  full_name = "Alice Smith"
  email = "alice@example.com"
}

resource "harbor_project" "solar" {
  name                        = "solar"
  public                      = false
  vulnerability_scanning      = true
  enable_content_trust        = true
  enable_content_trust_cosign = true
  auto_sbom_generation        = true
}

resource "harbor_project_member_user" "solar" {
  project_id    = harbor_project.solar.id
  user_name     = "alice"
  role          = "projectadmin"
}

resource "harbor_user" "alice" {
  username = "alice"
  password = "Alice$01"
  full_name = "Alice Smith"
  email = "alice@example.com"
}

resource "harbor_user" "bob" {
  username = "bob"
  password = "Bobby$01"
  full_name = "Bob Smith"
  email = "bob@example.com"
}


resource "harbor_project" "solar" {
  name                        = "solar"
  public                      = false
  vulnerability_scanning      = true
  enable_content_trust        = true
  enable_content_trust_cosign = true
  auto_sbom_generation        = true
  storage_quota               = "2"
}

resource "harbor_project_member_user" "solar" {
  project_id    = harbor_project.solar.id
  user_name     = "alice"
  role          = "projectadmin"
}

resource "harbor_project" "wind" {
  name                        = "wind"
  public                      = false
  vulnerability_scanning      = true
  enable_content_trust        = true
  enable_content_trust_cosign = true
  auto_sbom_generation        = true
  storage_quota               = "2"
}

resource "harbor_project_member_user" "wind" {
  project_id    = harbor_project.wind.id
  user_name     = "bob"
  role          = "master"
}

resource "harbor_project_member_user" "wind-guest" {
  project_id    = harbor_project.wind.id
  user_name     = "alice"
  role          = "guest"
}


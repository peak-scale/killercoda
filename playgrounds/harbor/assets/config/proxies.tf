resource "harbor_registry" "dockerhub" {
  name          = "dockerhub"
  provider_name = "docker-hub"
  endpoint_url  = "https://hub.docker.com"
}

resource "harbor_project" "dockerhub" {
  name                   = "dockerhub"
  public                 = true
  enable_content_trust   = "true"
  vulnerability_scanning = "true"
  force_destroy          = true
  registry_id            = harbor_registry.dockerhub.registry_id
}

resource "harbor_registry" "gcr" {
  name          = "gcr"
  provider_name = "docker-registry"
  endpoint_url  = "https://gcr.io"
}

resource "harbor_project" "gcr" {
  name                   = "gcr"
  public                 = true
  enable_content_trust   = "true"
  vulnerability_scanning = "true"
  force_destroy          = true
  registry_id            = harbor_registry.gcr.registry_id
}

resource "harbor_registry" "k8s" {
  name          = "k8s"
  provider_name = "docker-registry"
  endpoint_url  = "https://registry.k8s.io"
}

resource "harbor_project" "k8s" {
  name                   = "k8s"
  public                 = true
  enable_content_trust   = "true"
  vulnerability_scanning = "true"
  force_destroy          = true
  registry_id            = harbor_registry.k8s.registry_id
}

resource "harbor_registry" "chainguard" {
  name          = "chainguard"
  provider_name = "docker-registry"
  endpoint_url  = "https://cgr.dev"
}

resource "harbor_project" "chainguard" {
  name                   = "chainguard"
  public                 = true
  enable_content_trust   = "true"
  vulnerability_scanning = "true"
  force_destroy          = true
  registry_id            = harbor_registry.chainguard.registry_id
}


resource "harbor_registry" "aws" {
  name          = "aws"
  provider_name = "docker-registry"
  endpoint_url  = "https://public.ecr.aws"
}

resource "harbor_project" "aws" {
  name                   = "aws"
  public                 = true
  enable_content_trust   = "true"
  vulnerability_scanning = "true"
  force_destroy          = true
  registry_id            = harbor_registry.aws.registry_id
}

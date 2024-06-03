> [Documentation](https://opentofu.org/docs/language/resources/syntax/)

# Tasks

Complete these tasks for this scenario. 

## Task 1: Resource syntax


Resource declarations can include a number of advanced features, but only a small subset are required for initial use. 

```hcl
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "production"
  }
}
```

A resource block declares a resource of a given type [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) with a given local name `"namespace"`. The name is used to refer to this resource from elsewhere in the same module (argument references), but has no significance outside that module's scope.

The resource type and name together serve as an identifier for a given resource and so must be unique within a module.

Within the block body (between `{` and `}`) are the configuration arguments for the resource itself. Most arguments in this section depend on the resource type, and indeed in this example the `metadata.name` argument is defined specifically for the [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) resource type. Since you know how to lookup resources, you can find the required arguments for the resource type you are using.


## Task 2: Create Resources

Create a new file called `kubernetes.tf` in the current working directory. Within the file we want to create some resources, create the resources according to the following specifications:

Create a [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) with the local name `namespace` and the following argument-block:

```hcl
  metadata {
    name = "prod-environment"
  }
```{{copy}}

Create a [`kubernetes_service_account_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) with the local name `serviceaccount` and the following argument-block:

```hcl
  metadata {
    name = "prod-sa"
    namespace = "prod-environment"
  }
```{{copy}}


Create a [`kubernetes_secret_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) with the local name `serviceaccount_token` and the following argument-block:

```hcl
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "prod-sa"
    }
    namespace = "prod-environment"
    generate_name = "terraform-example-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
```{{copy}}

Create a [`kubernetes_pod_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1) with the local name `workload` and the following argument-block:

```hcl
  metadata {
    name = "nginx"
    namespace = "prod-environment"
  }
  
  spec {
    service_account_name = "prod-sa"
    container {
      image = "nginx:latest"
      name  = "nginx"
      port {
        container_port = 80
      }
    }
  }
```{{copy}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step1/`.


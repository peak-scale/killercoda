# Tasks

Complete these tasks for this scenario. 

## Task 1: Understand the resource syntax


Resource declarations can include a number of advanced features, but only a small subset are required for initial use. More advanced syntax features, such as single resource declarations that produce multiple similar remote objects, are described later in this page.

```hcl
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "production"
  }
}
```

A resource block declares a resource of a given type ("kubernetes_namespace_v1") with a given local name ("namespace"). The name is used to refer to this resource from elsewhere in the same module, but has no significance outside that module's scope.

The resource type and name together serve as an identifier for a given resource and so must be unique within a module.

Within the block body (between `{` and `}`) are the configuration arguments for the resource itself. Most arguments in this section depend on the resource type, and indeed in this example the `metadata.name` argument is defined specifically for the `kubernetes_namespace_v1` resource type. Since you know how to lookup resources, you can find the required arguments for the resource type you are using.


## Task 2: Create Resources

Create a new file called `kubernetes.tf` in the current working directory. Within the file we want to create some resources, create the resources according to the following specifications:

  * Create a [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) resource called `prod-environment`.
  * Create a [`kubernetes_service_account_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) resource called `prod-sa` in the `prod-environment` namespace.

And add these two resources to the file:

```hcl
resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "prod-sa"
    }
    namespace = "prod-environment"
    generate_name = "terraform-example-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_pod_v1" "workload" {
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
}
```{{copy}}




There's a file located in your working directory called `kubernetes.tf`. Review the content of the file. 

```shell
cat kubernetes.tf
```{{execute}}

You will notice that there are redundant values in the configuration:

* `prod-environment`: The namespace name is used in multiple resources.
* `prod-sa`: The service account name is used in multiple resources.

## Task 2: Implement Resource Attribute References

Rewrite the file `kubernetes.tf` to use the resource attributes instead of hardcoding the values. This is how you can reference the attributes:

* `kubernetes_namespace_v1.namespace.metadata.0.name` for the namespace name.

* `kubernetes_service_account_v1.serviceaccount.metadata.0.name` for the serviceaccount name.

> You can just replace the values with the resource attributes, no further changes to the file are required.

## Task 3: Review

If you now run the `plan` command, you should see that the configuration is still valid and nothing changed, where we replaced the values with the resource attributes.

```shell
tofu plan
```{{execute}}

<hr>

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step1/`.


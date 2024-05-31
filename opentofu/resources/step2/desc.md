> [Documentation](https://opentofu.org/docs/language/resources/syntax/#meta-arguments)

We need to influence the lifecycle of some of the resources we are going to create.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Create a dependency

> [Documentation](https://opentofu.org/docs/language/meta-arguments/depends_on/)

The resource `kubernetes_pod_v1` requires the `kubernetes_service_account_v1` to be created first. To ensure that the `kubernetes_pod_v1` resource is created after the `kubernetes_service_account_v1` resource, you can use the `depends_on` meta-argument. Implement the `depends_on` meta-argument in the `kubernetes_pod_v1` resource, so that it depends on the `kubernetes_service_account_v1.serviceaccount` resource.

## Task 3: Plan and Apply

Execute the plan and apply the changes:

```shell
tofu plan
```{{execute}}

```shell 
tofu apply
```{{execute}}




## Task 2: Ignore Changes

Often when working with Kubernetes resources, there are other systems interacting with these resources on the infrastructure. They might apply and add changes, which are required for the resource to work properly. However this leads to a change drift in the configuration. To prevent these changes from being applied, you can use the `ignore_changes` meta-argument. In this case, we want to ignore some of the annotations that are added by the Kubernetes CNI.


The following attributes should be ignored:

* `metadata[0].annotations["cni.projectcalico.org/podIP"]`
* `metadata[0].annotations["cni.projectcalico.org/containerID"]`
* `metadata[0].annotations["cni.projectcalico.org/podIPs"]`








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


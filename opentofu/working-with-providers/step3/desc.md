Now we have setup the provider and the configuration for the provider. We can now start working with the provider. Let's create some Kubernetes resources.

# Tasks

Complete these tasks for this scenario:

## Task 1: Create a new namespace

Create a new file called `namespace.tf`. Within create a [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1). The namspace should be called `dev-environment`.

## Task 2: Create a ServiceAccount

Create a new file called `serviceaccount.tf`. Within create a [`kubernetes_service_account_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1). The ServiceAccount should be called `dev-sa` and should be in the `dev-environment` namespace. To ensure that the ServiceAccount is in the correct namespace, you can use the `metadata` block:

```shell
  metadata {
    namespace = "dev-environment"
  }
```{{copy}}

## Task 3: Create a Pod

Create a new file called `pod.tf`. Within create a [`kubernetes_pod_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1). The Pod should be called `dev-pod` and should be in the `dev-environment` namespace. To ensure that the Pod is in the correct namespace, you can use the `metadata` block:

```shell
  metadata {
    namespace = "dev-environment"
  }
```{{copy}}

The Pod should have a container called `nginx` which uses the `nginx:latest` image. The container should listen on port `80`. The Pod should use the serviceaccount `dev-sa`.


## Task 4: Plan and Apply

We want to apply the given changes to the Kubernetes cluster. To do this, we need to create a plan and apply it.

1. Create a plan by running:

```shell
tofu plan
```{{exec}}

2. Apply the plan by running:

```shell
tofu apply
```{{exec}}

Resolve any potential errors.

# Check

> If the verification was not successful and you are unsure what the problem is, review the  `~/.solutions/step2/provider.tf` file.


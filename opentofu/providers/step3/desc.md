Now we have setup the provider and the configuration for the provider. We can now start working with the provider. Let's create some Kubernetes resources.

# Tasks

Complete these tasks for this scenario:

## Task 1: Create a new namespace

Create a new file called `namespace.tf`. Within create a [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1). The namspace should be called `dev-environment`. Use the following arguments:

```shell
  metadata {
    name = "dev-environment"
  }
```{{copy}}


## Task 2: Create a ServiceAccount

Create a new file called `serviceaccount.tf`. Within create a [`kubernetes_service_account_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1). The ServiceAccount should have `name` `dev-sa` and should be in the `dev-environment` `namespace`. Use the following arguments:

```shell
  metadata {
    name = "dev-sa"
    namespace = "dev-environment"
  }
```{{copy}}

## Task 3: Create a Pod

Create a new file called `pod.tf`. Within create a [`kubernetes_pod_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1). The Pod should have the `name` `dev-pod` and should be in the `dev-environment` `namespace`. 

* The Pod should have a container called `nginx` (use argument `spec.container.name`)
* The container should use the `nginx:latest` image (use argument `spec.container.image`)
* The Pod should use the serviceaccount `dev-sa` (use argument `spec.service_account_name`)

## Task 4: Apply

Deploy the Kubernetes resources:

```shell
tofu apply -auto-approve
```{{exec}}


Resolve any potential errors.


# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step3/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step3/* ~/scenario/`{{copy}}.
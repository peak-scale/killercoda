To demonstrate an import conflict, we extended the resources and working against a Kubernetes cluster.

## Tasks

Complete these tasks for this scenario.

### Task 1: Review Setup

We have added the [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) provider to the configuration. You may review the `provider.tf` file:

```shell
cat ~/scenario/provider.tf
```{{exec}}

We have added a file `kubernetes.tf` which contains a simple Kubernetes resource:

```shell
cat ~/scenario/kubernetes.tf
```{{exec}}



> [Documentation](https://opentofu.org/docs/cli/commands/import/)

The capability to import state is crucial when you have an existing infrastructure that you want to manage with OpenTofu. This is a common scenario when you are migrating from another infrastructure as code tool or when you have manually created resources.

We want to simulate a situation, where the file `morning.txt` is already present on a machine but not in our state. Create the file:

```shell
cat  > morning.txt <<EOF
Hello, World!
EOF
```{{exec}}

Our state currently does not know about the file `morning.txt`. You can verify this by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

Now we are expecting to get a conflict when running:

```shell
tofu plan & tofu apply
```{{exec}}


> [Documentation](https://opentofu.org/docs/cli/commands/import/)


  
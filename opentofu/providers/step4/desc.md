You will often encounter this scenario with cloud vendors: you need the same provider multiple times with different
configuration e.g. in a different region. In this case you can use the `provider` meta-argument to specify the provider
configuration for a resource.

# Tasks

Complete these tasks for this scenario:

## Task 1: Create new Provider

> See the documentation [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs).

In our example, we are having a problems with pod annotations which are always added by the infrastructure. In
the `provider.tf` file, create a new provider for `kubernetes` which always ignores the following annotations:

* `"cni\\\\.projectcalico\\\\.org\\\\/*"`{{copy}}

The [`alias`](https://opentofu.org/docs/language/providers/configuration/#alias-multiple-provider-configurations) for
the provider should be `k8s`{{copy}}.

## Task 2: Use the provider

> See the documentation [resource-provider](https://opentofu.org/docs/language/meta-arguments/resource-provider/).

In the `pod.tf` file, use the provider `k8s` for the `kubernetes_pod_v1` resource. All the other configurations should
remain the same.

When a provider has an `alias`, it's not the default provider and must be specified in the resource/data source block.

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files
> in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by
> running `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.

> [Documentation](https://opentofu.org/docs/language/data-sources/#using-data-sources)

# Tasks

Complete these tasks for this scenario. 

## Task 1: Resource syntax

A data source is accessed via a special kind of resource known as a data resource, declared using a `data` block:

```hcl
data "kubernetes_pod_v1" "workload" {
  metadata {
    name = "nginx"
  }
}
```

For each daa source you need to supply different arguments, in this case the `metadata` block with the `name` argument. [See the reference](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/pod_v1#argument-reference). Always consult the documentation to find the required arguments for the data source you are using.

A data block requests that OpenTofu read from a given data source ([kubernetes_pod_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/pod_v1)) and export the result under the given local name (`workload`). The name is used to refer to this resource from elsewhere in the same OpenTofu module, but has no significance outside of the scope of a module.

Usually every resource has a data source equivalent.

## Task 2: Create Data Sources

There's a new file called `kubernetes.tf` in the current working directory. For each of the mentioned resources, create a data source in a file called `sources.tf`:

* [`kubernetes_namespace_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/namespace_v1): Use local name `namespace`
* [`kubernetes_service_account_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account_v1): Use local name `serviceaccount`
* [`kubernetes_secret_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret_v1): Use local name `serviceaccount_token`
* [`kubernetes_pod_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/pod_v1): Use local name `workload`


For the argument `name` use the argument of the counter-part resource. For example, for the `kubernetes_namespace_v1` use `kubernetes_namespace_v1.namespace.metadata.0.name` as the argument for the `name` parameter. Same for the `namespace` argument.


## Task 3: Output Data

To make it clear for us what data is returned by the data sources, we want to output the data to the console. Add an output block to the `outputs.tf` file:

```hcl
output "namespace" {
  value = data.kubernetes_namespace_v1.namespace
}

output "service_account" {
  value = data.kubernetes_service_account_v1.serviceaccount
}

output "secret" {
  sensitive = true
  value = data.kubernetes_secret_v1.serviceaccount_token
}

output "pod" {
  value = data.kubernetes_pod_v1.workload
}
```{{copy}}

This instructs OpenTofu to output the data from the data sources to the console. The `sensitive` argument is used to hide the output from the console.

## Task 4: Plan

Run `tofu plan`{{exec}} to review the data sources. Focus your attention to the Changes to outputs section:

```
Changes to Outputs:
  + namespace       = {
      + id       = (known after apply)
      + metadata = [
```

Most of the attributes have the value `(known after apply)`, which makes sense since we are fetching data from the infrastructure with the data source statement.

## Task 4: Apply

Run `tofu apply`{{exec}} to apply the changes. This will create the resources and once finished output the data to the console:

```shell
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

namespace = {
  "id" = "prod-environment"
  "metadata" = tolist([
    {
      "annotations" = tomap({})
      "generation" = 0
      "labels" = tomap({
        "kubernetes.io/metadata.name" = "prod-environment"
      })
      "name" = "prod-environment"
      "resource_version" = "3756"
      "uid" = "0b9bfd41-c6c3-48e6-88c2-6c362dc774fb"
    },
  ])
  "spec" = tolist([
    {
      "finalizers" = tolist([
        "kubernetes",
      ])
    },
  ])
}
pod = {
  "id" = "prod-environment/nginx"
  "metadata" = tolist([
    {
      "annotations" = tomap({
        "cni.projectcalico.org/containerID" = "204e985ea380ee993e9bc8705153ec9d56de2561b6510656f9f01616b3873533"
        "cni.projectcalico.org/podIP" = "192.168.0.6/32"
        "cni.projectcalico.org/podIPs" = "192.168.0.6/32"
      })
      "generate_name" = ""
      "generation" = 0
      "labels" = tomap({})
      "name" = "nginx"
...
```

We can now see, that the resources have much more data than we initially defined. All this data was enriched by the Infrastructure Platform. Now we can reuse this data for further processing

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step1/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step1/* ~/scenario/`{{copy}}.


Now we are going to use data retrieved from a data source to establish owner references on the resources we are creating. This is not a real world scenario, but it's a good example to show how you can use data sources to enrich your configuration.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Add Namespace UID

Add the `namespace-uid` annotation to all resources in the `kubernetes.tf` file, except for the `kubernetes_namespace_v1` resource. The `namespace-uid` should be the UID of the namespace created in the `kubernetes_namespace_v1` resource.

```hcl
metadata {
    annotations = {
        "namespace-uid" = data.kubernetes_namespace_v1.namespace.metadata.0.uid
    }
}
```

`tofu plan`{{execute}} and `tofu apply`{{execute}} the configuration.

## Task 2: Add Pod UID

Add the `pod-uid` annotation to the `kubernetes_namespace_v1` in the `kubernetes.tf` file, except for the `kubernetes_namespace_v1` resource:

```hcl
metadata {
    annotations = {
        "pod-uid" = data.kubernetes_pod_v1.workload.metadata.0.uid
    }
}
```

`tofu plan`{{execute}} and `tofu apply`{{execute}} the configuration.

There's a problem with the configuration. The cycle we are trying to implement is not allowed, because we are creating a circular dependency. We need to fix this by removing the `pod-uid` annotation from the `kubernetes_namespace_v1` resource

> Another option would be to remove all the references from the `kubernetes_pod_v1` resource to the `kubernetes_namespace_v1` resource. This also resolves the circular dependency.

```shell

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step2/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step2/* ~/scenario/`{{copy}}.


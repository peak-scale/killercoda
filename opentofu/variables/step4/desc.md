> [Documentation](https://opentofu.org/docs/language/values/locals/)

Local values assign names to expressions for reuse in a module. They are similar to variables, but they are only used
within the module where they are declared. They cannot be set from the outside, and they are not included in the output
variables of a module.

Local values can be helpful to avoid repeating the same values or expressions multiple times in a configuration, but if
overused they can also make a configuration hard to read by future maintainers by hiding the actual values used.

**Note**: Local variables can be declared in any `.tf` file in the module directory.

# Tasks

Complete these tasks for this scenario.

## Task 1: Create local values

> [Documentation](https://opentofu.org/docs/language/values/locals/#declaring-a-local-value)

Let's create a new file called `locals.tf` in your working directory. Define the following local values:

```shell
locals {
  common_labels = {
    environment = var.environment
  }
}
```{{copy}}

## Task 2: Use local values

These labels should be used in the `kubernetes_pod_v1` resources in the `kubernetes.tf`. Assign it to the `metadata`
block in the for the `labels` attribute. You can reference the local variable by calling `local.common_labels`. Example:

```shell
  metadata {
    ...
    labels = HERE
  }
```{{copy}}

## Task 3: Extend locals

 Append a new local value called `deploy_annotations` to the `locals` block in the `locals.tf` file. Add the following
values to the `deploy_annotations`:

```shell
locals {
  ...
  deploy_annotations = {
    created_at = timestamp()
  }
}
```{{copy}}

## Task 4: Use local values

These annotations should be used in the `kubernetes_pod_v1` resources in the `kubernetes.tf`. Assign it to the
`metadata` block in the for the `annotations` attribute. You can reference the local variable by calling
`local.deploy_annotations`. Example:

```shell
  metadata {
    ...
    annotations = HERE
  }
```{{copy}}

## Task 5: Plan and Apply

Execute the plan and apply the changes:

```shell
tofu apply -var-file=prod.tfvars
```{{execute}}

If you look at the resulting pod, you should see the labels and annotations:

```shell
 kubectl get pod -n prod-environment nginx -o json | jq '.metadata'
```{{execute}}

```json
{
  "annotations": {
    ....
    "created_at": "2024-09-02T16:09:32Z"
  },
  "labels": {
    "environment": "prod"
    ...
  },
}
```

# Verify

> If the verification was not successful (the check button) and you are unsure what the problem is, review the solution
> generated in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by running
> `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.

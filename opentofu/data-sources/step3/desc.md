# Tasks

Complete these tasks for this scenario. 

## Task 1: Selecting a Non-default Provider Configuration

> [Documentation](https://opentofu.org/docs/language/data-sources/#selecting-a-non-default-provider-configuration)

For the data source `kubernetes_namespace_v1` in the `sources.tf`, use the provider called `k8s`. 

## Task 2: Custom Condition

> [Documentation](https://opentofu.org/docs/language/data-sources/#custom-condition-checks)

Since we are creating a `postcondition`, we can use
the [`self`](https://opentofu.org/docs/language/expressions/custom-conditions/#self-object) keyword to refer to the
resource itself. Add a `postcondition` to the `kubernetes_pod_v1` data source in the `sources.tf` file:

  * `condition`: The `self.status` is equal to `Running`
  * `error_message`: `"Pod is not in the Running phase"`

If you `tofu apply -auto-approve`{{exec}} you should not get any errors, because the pod is in the `Running` phase.

# Verify

> If the verification was not successful (the check button) and you are unsure what the problem is, review the solution
> generated in `~/.solutions/step3/`. You can always copy the solution files to the current working directory by
> running `cp ~/.solutions/step3/* ~/scenario/`{{copy}}.

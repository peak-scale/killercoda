> [Documentation](https://opentofu.org/docs/language/values/outputs/)

Output variables are used to expose values from a module for use in other modules or as a return value to the user who invoked the module. They are useful for extracting information about the infrastructure provisioned by a module.

### Tasks

Complete these tasks for this scenario.

#### Task 1: Create output variables

> [Documentation](https://opentofu.org/docs/language/values/outputs/#declaring-an-output-value)

Let's create a new file called `outputs.tf` in your working directory. Define the following output variables:

```shell
output "pod_name" {
  description = "The name of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].name
}
```{{copy}}

Here we use the attribute `metadata[0].name` to extract the name of the pod. This is an attribute we declared and is therefor known before any apply has been made.

#### Task 2: Use output variables

These output variables should be used to expose the information from the Kubernetes resource on the infrastructure. Add the following output to the `outputs.tf` file:

```shell
output "pod_uid" {
  description = "The UID of the Kubernetes pod"
  value       = kubernetes_pod_v1.workload.metadata[0].uid
}
```{{copy}}

The attribute status we are accessing is only available after the resource has been created.

#### Task 3: Inspect the outputs

We can view the current outputs with:

```shell
tofu output
```{{execute}}

However we get the feedback, that no outputs have yet been defined. This is because the resources have not been applied yet. Let's run a plan:

```shell
tofu plan
```{{execute}}

If you look closely, you can see new outputs being declared at the bottom of the plan:

```shell
...

Changes to Outputs:
  + pod_name = "nginx"
  + pod_uid  = (known after apply)
```

Apply the configuration to see the outputs:

```shell
Outputs:

pod_name = "nginx"
pod_uid = "aec67ce7-91c9-4e82-b191-a887201e852b"
```

You can now also inspect the outputs with:

```shell
tofu output -json
```{{execute}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step5/`.

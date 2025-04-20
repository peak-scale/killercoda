> [Documentation](https://opentofu.org/docs/language/meta-arguments/lifecycle/)

Each resource supports the `lifecycle` meta-argument and the `depends_on` meta-argument. These arguments can be used to
control the behavior of the resource during the lifecycle of the resource. The `lifecycle` block supports the following
arguments: `create_before_destroy`, `prevent_destroy`, `ignore_changes`, and `replace_triggered_by`. An example is
provided below.

```hcl
resource "kubernetes_namespace_v1" "example" {
  # ...
  lifecycle {
    create_before_destroy = true
  }
}
```

# Tasks

Complete these tasks for this scenario. 

## Task 1: Create a dependency

> [Documentation](https://opentofu.org/docs/language/meta-arguments/depends_on/)

The resource `kubernetes_pod_v1` requires the `kubernetes_service_account_v1` to be created first. To ensure that
the `kubernetes_pod_v1` resource is created after the `kubernetes_service_account_v1` resource, you can use 
the `depends_on` meta-argument.

Implement the `depends_on` meta-argument in the `kubernetes_pod_v1` resource so that it depends on 
the `kubernetes_service_account_v1` resource in the file `scenario/kubernetes.tf`. 

Execute the plan and apply the changes:

```shell
tofu apply -auto-approve
```{{exec}}

In truth, this particular case of `depends_on` is not needed since we can implicitly specify the dependency by referencing
the attributs of the first object in the second one, as specified below.

> Instead of `depends_on`, we recommend using [expression references](https://opentofu.org/docs/language/expressions/references/)
> to imply dependencies when possible. Expression references let OpenTofu understand which value the reference derives
> from and avoid planning changes if that particular value hasn’t changed, even if other parts of the upstream object
> have planned changes.


## Task 2: Ignore Changes

> [Documentation](https://opentofu.org/docs/language/meta-arguments/lifecycle/)

While doing the above you have noticed annotations which are being replaced, but somehow they look important:

```shell
      ~ metadata {
          ~ annotations      = {
              - "cni.projectcalico.org/containerID" = "9c54a1c6e5a0596785139e1b654cfc0453d84566fbe2d5d53dab1ec1ff5ebf30" -> null
              - "cni.projectcalico.org/podIP"       = "192.168.0.6/32" -> null
              - "cni.projectcalico.org/podIPs"      = "192.168.0.6/32" -> null
            }
            name             = "nginx"
            # (5 unchanged attributes hidden)
        }
```

Often, when working with Kubernetes resources, there are other systems interacting with these resources on the
infrastructure. They might apply and add changes that are required for the resource to work properly. However, this
leads to a change drift in the configuration. To prevent these changes from being applied, you can use
the `ignore_changes` meta-argument.

The following attributes should be ignored:

* `metadata[0].annotations["cni.projectcalico.org/podIP"]`{{copy}}
* `metadata[0].annotations["cni.projectcalico.org/containerID"]`{{copy}}
* `metadata[0].annotations["cni.projectcalico.org/podIPs"]`{{copy}}

Run a plan again and you will see that the changes are ignored.

## Task 3: Custom Conditions

> [Documentation](https://opentofu.org/docs/language/expressions/custom-conditions/#preconditions-and-postconditions)

On the `kubernetes_pod_v1` resource, add a `precondition` block in the `lifecycle` block:

* `condition`: Value of `kubernetes_namespace_v1.namespace.metadata[0].name`{{copy}} is not equal to `prod-environment`{{copy}}
* `error_message`: `"The namespace must not be prod-environment"`{{copy}}

# Verify

> If the verification was not successful (the check button) and you are unsure what the problem is, review the solution
> generated in `~/.solutions/step3/`. You can always copy the solution files to the current working directory by
> running `cp ~/.solutions/step3/* ~/scenario/`{{copy}}.

There's other options to control the lifecycle of a resource. You can find more information in 
the [documentation](https://opentofu.org/docs/language/meta-arguments/lifecycle/).

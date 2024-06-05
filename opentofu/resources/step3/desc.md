> [Documentation](https://opentofu.org/docs/language/meta-arguments/lifecycle/)

Each resource supports lifecycle arguments. These arguments can be used to control the behavior of the resource during the lifecycle of the resource. The lifecycle block supports the following arguments:

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

The resource `kubernetes_pod_v1` requires the `kubernetes_service_account_v1` to be created first. To ensure that the `kubernetes_pod_v1` resource is created after the `kubernetes_service_account_v1` resource, you can use the `depends_on` meta-argument. Often these dependencies are solved by the provider, but in some cases you need to enforce the dependency or in this case there can be a racing condition.

Implement the `depends_on` meta-argument in the `kubernetes_pod_v1` resource, so that it depends on the `kubernetes_service_account_v1.serviceaccount` resource in the file `scenario/kubernetes.tf`.

Execute the plan and apply the changes:

```shell
tofu apply -auto-approve
```{{exec}}

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

Often when working with Kubernetes resources, there are other systems interacting with these resources on the infrastructure. They might apply and add changes, which are required for the resource to work properly. However this leads to a change drift in the configuration. To prevent these changes from being applied, you can use the `ignore_changes` meta-argument.

The following attributes should be ignored:

* `metadata[0].annotations["cni.projectcalico.org/podIP"]`
* `metadata[0].annotations["cni.projectcalico.org/containerID"]`
* `metadata[0].annotations["cni.projectcalico.org/podIPs"]`

Run a plan again and you will see that the changes are ignored.


## Task 3: Condition Checks

> [Documentation](https://opentofu.org/docs/language/expressions/custom-conditions/#preconditions-and-postconditions)

On the `kubernetes_pod_v1` resource, add a `precondition`:
  * `condition`: Value of `kubernetes_namespace_v1.namespace.metadata[0].name` is equal to `prod-environment`
  * `error_message`: "The namespace must be prod-environment"

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step3/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step3/* ~/scenario/`{{copy}}.

There's other options to control the lifecycle of a resource. You can find more information in the [documentation](https://opentofu.org/docs/language/meta-arguments/lifecycle/)
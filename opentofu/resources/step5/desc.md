> [Documentation](https://opentofu.org/docs/language/meta-arguments/for_each/).

As seen with the `count` argument, we can iterate over primitive values. The `for_each` argument is used to iterate over a `map` or a `set` of strings. This allows us to create complexer iterations of resources. [Read more](https://opentofu.org/docs/language/meta-arguments/count/#when-to-use-for_each-instead-of-count)

**Note:** A given resource or module block cannot use both `count` and `for_each`.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Add Variable

Create a new file called `pods-foreach.tf`{{copy}} in the current working directory. Add a new local variable called `workloads`. Here's the skeleton for the variable:

```shell
locals {
  workloads = []
}
```{{copy}}

## Task 2: Populate Data

The `workloads` variable should be a [list](https://opentofu.org/docs/language/expressions/types/#liststuples) of [maps](https://opentofu.org/docs/language/expressions/types/#mapsobjects). The following elements should be added to the `workloads` list:

  - **name**: `busybox`<br>
    **image**: `busybox:latest`

  - **name**: `alpine`<br>
    **image**: `alpine:latest`

  - **name**: `bash`<br>
    **image**: `bash:latest`
    
Correctly populate the `workloads` variable with the given data.

## Task 3: Convert Data Structure

> [Documentation](https://opentofu.org/docs/language/meta-arguments/for_each/#chaining-for_each-between-resources). There's no conclusive documentation on this topic.

Our data is now of type `list(map(string))`. We need to convert it to a `map` to use it with the `for_each` meta-argument. While you might say we can just adjust input variable, we want to keep the original data structure (This is to showcase the situation when you have returned data, which's structure you can't control).

In our case we will use the following expression:

```hcl
{ for idx, workload in local.workloads : idx => workload }
```

This expression converts the `local.workloads` list into a map:

* `for idx, workload in local.workloads` iterates over each element in the list along with its index (`idx`).

* `idx => workload` creates a key-value pair for each element where `idx` is the key and `workload` is the value. 

So our data looks like this after that remapping:

```shell
{
  0 = {
    name = "busybox"
    image = "busybox:latest"
  }
  1 = {
    name = "alpine"
    image = "alpine:latest"
  }
  2 = {
    name = "bash"
    image = "bash:latest"
  }
}
```

## Task 4: Implement `for_each`

Given the variable `workloads` we want to be able to iterate over the variable and create for each element a dedicated pod.

Create a new [kubernetes_pod_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1) resource in the `pods-foreach.tf` file. Use the `for_each` meta-argument to create multiple instances of a resource based on the value of `local.workloads`. Here's the skeleton for the resource:

```hcl
resource "kubernetes_pod_v1" "for-workload" {
  for_each = { for idx, workload in local.workloads : idx => workload }

  metadata {
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    container {
      command = ["sleep", "infinity"]
    }
  }
}
```{{copy}}

> [Documentation](https://opentofu.org/docs/language/meta-arguments/for_each/#the-each-object)

* The pods should be named `${each.value.name}`{{copy}} (use argument `metadata.name`). 
* The container should be named `${each.value.name}`{{copy}} (use argument `spec.container.name`).
* The image should be `${each.value.image}`{{copy}} (use argument `spec.container.image`).

Execute `tofu plan`{{exec}}  and `tofu apply`{{exec}} to see the changes.

## Task 5: Resolve Conflict

> [Documentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1#import).

While executing the apply command, you will see an error. Can you resolve the conflict? You should be able to deploy all the pods `tofu apply`{{exec}} should not throw an error anymore.

## Task 6: Verify on Kubernetes

Verify the resources on the Kubernetes cluster:

```shell
kubectl get pod -n dev-environment
```{{exec}}

We can see our new pods:

```shell
NAME            READY   STATUS    RESTARTS   AGE
...
alpine                 0/1     CrashLoopBackOff   7 (49s ago)   11m
bash                   0/1     CrashLoopBackOff   7 (39s ago)   11m
busybox                1/1     Running            0             2s
```

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step5/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step5/* ~/scenario/`{{copy}}.

**Note:** A given resource or module block cannot use both `count` and `for_each`.


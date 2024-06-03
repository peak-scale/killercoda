By default, a resource block configures one real infrastructure object (and similarly, a module block includes a child module's contents into the configuration one time). However, sometimes you want to manage several similar objects (like multiple pods) without writing a separate block for each one. 

There's a new file called `locals.tf` in the current working directory. The file contains variables used for this scenario. 

# Tasks

Complete these tasks for this scenario. 

## Task 1: Add Foreach Replicas
> [Documentation](https://opentofu.org/docs/language/meta-arguments/count/).

Count is the simple way to make our pods scalable. We can use the `count` meta-argument to create multiple instances of a resource. Based on the value of `local.replicas`, which is currently `3` we want to create that amount of pods. Create new file called `pods-count.tf` in the current working directory. Create a new [kubernetes_pod_v1]() resource. Use the `count` meta-argument to create multiple instances of a resource based on the value of `local.replicas`. The pods should be named `nginx-count-${count.index}` (use argument `metadata.name`).

```shell

```
resource "kubernetes_pod_v1" "workload" {
  count = local.replicas

  metadata {
    name = "nginx-count-${count.index}"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    container {
      image = "nginx:latest"
      name  = "nginx"
      port {
        container_port = 80
      }
    }
  }

  lifecycle {
    ignore_changes = [
        metadata[0].annotations["cni.projectcalico.org/containerID"],
        metadata[0].annotations["cni.projectcalico.org/podIP"],
        metadata[0].annotations["cni.projectcalico.org/podIPs"]
    ]
  }
}
```{{copy}}


## Task 2: Fix Problems

When you run the `tofu plan`{{exec}}, you will see that tofu will create 3 pods. But wait there's a problem 🤔. Can you fix that?

## Task 2: `for_each` loops (Replication)

> [Documentation](https://opentofu.org/docs/language/meta-arguments/for_each/).

* Create a new file called `pod-for.tf` in the current working directory. 
* Within the file we want to create a [`kubernetes_pod_v1`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1).
* Use a `for_each` loop based on the value of `local.replicas`.
* The pods should be named `nginx-${each.key}`.

You will probably encounter an error when running the `tofu plan`{{exec}}. Can you fix it?

```
│ The given "for_each" argument value is unsuitable: the "for_each" argument must be a map, or set of strings, and you have provided a value of type number.
```

Create a new local variable called `for_replicas`
```shell


## Task 3: Apply Replicas



## Task 3: Scale Replicas

Change the amount of replicas to `5` in the `locals.tf` file:




```shell
locals {
  replicas = 5
}
```{{execute}}

You can verify the existence of the resource on the target infrastructure

```shell 
kubectl get ns prod-environment
kubectl get sa -n prod-environment
kubectl get pod -n prod-environment
```{{execute}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.

**Note:** A given resource or module block cannot use both `count` and `for_each`.


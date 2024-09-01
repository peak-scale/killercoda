> [Documentation](https://opentofu.org/docs/language/meta-arguments/count/).

By default, a resource block configures one real infrastructure object (and similarly, a module block includes a child module's contents into the configuration one time). However, sometimes you want to manage several similar objects (like multiple pods) without writing a separate block for each one. 

There's a new file called `locals.tf` in the current working directory. The file contains variables used for this scenario. 

# Tasks

Complete these tasks for this scenario. 

## Task 1: Implement `count`

> [Documentation](https://opentofu.org/docs/language/meta-arguments/count/#the-count-object)

Create new file called `pods-count.tf` in the current working directory. Create a new [kubernetes_pod_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1) resource. Use the `count` meta-argument to create multiple instances of a resource based on the value of `local.replicas`{{copy}}. The pods should be named `nginx-count-${count.index}`{{copy}} (use argument `metadata.name`).

Add the asked attributes in this skeleton:

```hcl
resource "kubernetes_pod_v1" "workload" {
  metadata {
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
}
```{{copy}}



## Task 2: Fix Problems

When you run the `tofu plan`{{exec}}, you will see that tofu will create 3 pods. But wait there's a problem 🤔. Can you fix that (You can use any name)?

Once you have fixed the problem, `tofu apply`{{execute}} the changes.

## Task 3: Verify on Kubernetes

Verify the resources on the Kubernetes cluster:

```shell
kubectl get pod -n dev-environment
```{{exec}}

We can see our new pods:

```shell
NAME            READY   STATUS    RESTARTS   AGE
...
nginx-count-0   1/1     Running   0          23s
nginx-count-1   1/1     Running   0          23s
nginx-count-2   1/1     Running   0          24s
```

## Task 4: Scale Replicas

The current workload demends more Replicas of our app. Change the amount of replicas to `5` in the `locals.tf` file. once done `tofu apply`{{exec}} the changes.

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.

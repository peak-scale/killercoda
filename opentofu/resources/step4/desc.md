By default, a resource block configures one real infrastructure object (and similarly, a module block includes a child module's contents into the configuration one time). However, sometimes you want to manage several similar objects (like multiple pods) without writing a separate block for each one. 

There's a new file called `locals.tf` in the current working directory. The file contains variables used for this scenario. 

# Tasks

Complete these tasks for this scenario. 

## Task 1: Add Count Replicas
> [Documentation](https://opentofu.org/docs/language/meta-arguments/count/).

Count is the simple way to make our pods scalable. We can use the `count` meta-argument to create multiple instances of a resource. Based on the value of `local.replicas`, which is currently `3` we want to create that amount of pods. Create new file called `pods-count.tf` in the current working directory. Create a new [kubernetes_pod_v1]() resource. Use the `count` meta-argument to create multiple instances of a resource based on the value of `local.replicas`. The pods should be named `nginx-count-${count.index}` (use argument `metadata.name`).

## Task 2: Fix Problems

When you run the `tofu plan`{{exec}}, you will see that tofu will create 3 pods. But wait there's a problem 🤔. Can you fix that?

Once you have fixed the problem, `tofu apply`{{execute}} the changes.

## Task 3: Verify on Kubernetes

Verify the resources on the Kubernetes cluster:

```shell
kubectl get pod -n prod-environment
```

## Task 4: Scale Replicas

The current workload demends more Replicas of our app. Change the amount of replicas to `5` in the `locals.tf` file. once done `tofu apply`{{exec}} the changes.

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.
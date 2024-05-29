# Tasks

Complete these tasks for this scenario:

## Task 1: Review `production.tf`

We have created a new file called `production.tf` in your working directory. You may review it's content. One thing you might notice, is that we used references to terraform resources instead of hardcoding redundant values. For example with the namespace, which is used for all there resources, it's preferred to reference the resources value:

`kubernetes_namespace_v1.production.metadata.0.name`

## Task 2: Plan and Apply

Plan and Apply with the new given file `production.tf`.

```shell
tofu plan & tofu apply
```{{exec}}

There's an error, what does it indicate?

```
kubernetes_namespace_v1.production: Creating...
╷
│ Error: namespaces "prod-environment" already exists
│ 
│   with kubernetes_namespace_v1.production,
│   on production.tf line 1, in resource "kubernetes_namespace_v1" "production":
│    1: resource "kubernetes_namespace_v1" "production" {
```

Verify if the namespace `prod-environment` already exists in the cluster:

```shell
kubectl get ns prod-environment
```{{exec}}

Likely the other resources also exist:
    
```shell
kubectl get sa -n prod-environment
kubectl get pod -n prod-environment
```{{exec}}


1. Now it's time to create the file `hello.txt`. This is done by running the `apply` command:
```shell
tofu apply "/root/hello-example.plan"
```{{exec}}

The file `hello.txt` should now be created in the directory where the configuration is stored. You can check this by running the `ls` command:

```shell
ls
```{{exec}}

2. You can also verify the file is part of the state by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

3. Let's delete the file on the system manually.

```shell
rm hello.txt
```

4. Now, can you just apply the same plan again? What happens?

```shell
tofu apply "example-plan"
```{{exec}}

The plan is no longer valid, as the state was updated by our previous manual action. In order to apply the plan again, you need to create a new plan. 

5. Create a new plan by running the `plan` command:

```shell
tofu plan
```{{exec}}

This time we are not storing the plan to a dedicated file, because we can be sure, that no other changes can be made to our terraform configuration.

6. Apply the new plan, you must confirm the action by typing `yes`:

```shell
tofu apply
```{{exec}}

As you can see, there is an additional step when no plan file is provided. This is to ensure that you are aware of the changes that will be made to your infrastructure, which would have been done with a dedicated plan file (you must encoperate such a workflow yourself).


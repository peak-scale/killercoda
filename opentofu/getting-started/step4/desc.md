The command `plan` allows you to preview the changes OpenTofu will make before you apply them. The command `apply` makes the changes defined by your plan to create, update, or destroy resources.
## Tasks

Complete these tasks for this scenario.

### Task 1: Apply the Plan

Now it's time to create the file `hello.txt`. This is done by running the `apply` command:

```shell
tofu apply "/root/hello-example.plan"
```{{exec}}

The file `hello.txt` should now be created in the directory where the configuration is stored. You can check this by running the `ls` command:

```shell
cat hello.txt
```{{exec}}

You can also verify the file is part of the state by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

Let's delete the file on the system manually.

```shell
rm hello.txt
```{{exec}}

Now, can you just apply the same plan again? What happens?

```shell
tofu apply "/root/hello-example.plan"
```{{exec}}

The plan is no longer valid, as the state was updated by our previous manual action. In order to apply the plan again, you need to create a new plan. 

### Task 2: Replan

Create a new plan by running the `plan` command:

```shell
tofu plan
```{{exec}}

This time we are not storing the plan to a dedicated file, because we can be sure, that no other changes can be made to our terraform configuration.

### Task 3: Reapply

Apply the new plan, you must confirm the action by typing `yes`:

```shell
tofu apply
```{{exec}}

As you can see, there is an additional step when no plan file is provided. This is to ensure that you are aware of the changes that will be made to your infrastructure, which would have been done with a dedicated plan file (you must encoperate such a workflow yourself).

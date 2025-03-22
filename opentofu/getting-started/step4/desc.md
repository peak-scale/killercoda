The command `plan` lets you preview the changes OpenTofu will make before applying them. The command `apply` makes the
changes defined by your plan to create, update, or destroy resources.

## Tasks

Complete these tasks for this step:

### Task 1: Apply the plan

Now it's time to create the file `hello.txt`. This is done by running the `apply` command:

```shell
tofu apply "/root/hello-example.plan"
```{{exec}}

The file `hello.txt` should now be created in the directory where the configuration is stored. You can check this by
running the `cat` command:

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

The plan is no longer valid, as the state file was updated by our `apply` command and the file was manually removed.
In order to apply the configuration you need a new plan. 

### Task 2: Replan

Create a new plan by running the `plan` command:

```shell
tofu plan
```{{exec}}

This time we are not storing the plan to a dedicated file, but only showing the output.

### Task 3: Reapply

If you do `tofu apply` without passing a plan file, a new plan is automatically generated. To apply the new plan, you
confirm the action by typing `yes`:

```shell
tofu apply
```{{exec}}

As you can see, there is an additional plan when no plan file is provided. This is to ensure that you are aware of the
changes that will be made to your infrastructure, which would have been done with a dedicated plan file (if the changes
are simple you do a single `apply`, otherwise you export and read the plan before applying).

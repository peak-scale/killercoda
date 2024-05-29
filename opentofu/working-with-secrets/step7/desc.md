We have seen in the previous step, that when you delete a file manually, the state notices it's absence on a refresh (plan) operation and on the next apply it is recreated. Let's look at other scenarios where you might have conflicts between desired and actual state. 

### Import State

The capability to import state is crucial when you have an existing infrastructure that you want to manage with OpenTofu. This is a common scenario when you are migrating from another infrastructure as code tool or when you have manually created resources.

1. We want to simulate a situation, where the file `hello.txt` is already present on a machine but not in our state. For that, we are going to remove the file from the state:
```shell
tofu state rm local_file.example
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


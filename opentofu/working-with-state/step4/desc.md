Since our plan is ready, we can now apply it to create the file `hello.txt`. Let's do that in the next step.

### Applying your Plan

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


Working with state is the key aspect when it comes to consistency. It's not ideal to have the state just locally.

# Tasks

Remove the state file (never do this in production):
```shell
rm -f terra
```{{exec}}

The file `hello.txt` should now be created in the directory where the configuration is stored. You can check this by running the `ls` command:

```shell
ls
```{{exec}}

* You can also verify the file is part of the state by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

* Let's delete the file on the system manually.

```shell
rm hello.txt
```

* Now, can you just apply the same plan again? What happens?

```shell
tofu apply "example-plan"
```{{exec}}

The plan is no longer valid, as the state was updated by our previous manual action. In order to apply the plan again, you need to create a new plan. 

* Create a new plan by running the `plan` command:

```shell
tofu plan
```{{exec}}

This time we are not storing the plan to a dedicated file, because we can be sure, that no other changes can be made to our terraform configuration.

* Apply the new plan, you must confirm the action by typing `yes`:

```shell
tofu apply
```{{exec}}

As you can see, there is an additional step when no plan file is provided. This is to ensure that you are aware of the changes that will be made to your infrastructure, which would have been done with a dedicated plan file (you must encoperate such a workflow yourself).


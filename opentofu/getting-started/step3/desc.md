At the current stage, nothing has happened. We have just created a new project and initialized it. Let's apply the
configuration to create the file `hello.txt`.

## Tasks

Complete these tasks for this step:

### Task 1: Plan the changes

* Before anything is done, you should review the changes that will be made to your infrastructure. This is done by 
running the [plan command](https://opentofu.org/docs/cli/commands/plan):
```shell
tofu plan
```{{exec}}
As you can see, the plan indicates that a new file `hello.txt` should be created. We have certain attributes which are
not yet known, because the object does not yet exist on the system.

* Export the plan to a file called `/root/hello-example.plan`, this can be done just with `tofu`. Find the correct
argument to export the plan with `tofu plan`:

```shell
tofu plan -h
```{{exec}}

Saving a plan to a file is recommended to ensure that the plan is reviewed and approved before applying it. Otherwise,
unintended changes might be applied.

### Task 2: Convert the plan

The plan file is in binary format and not human-readable. You can use the `show` command to see its content.

```shell
tofu show /root/hello-example.plan
```{{exec}}

Store the output of the `show` command in a file called `/root/hello-example.plan.txt`. The shell allows you to do this
using the `>` operator.

```shell
tofu show /root/hello-example.plan > /root/hello-example.plan.txt
```{{exec}}

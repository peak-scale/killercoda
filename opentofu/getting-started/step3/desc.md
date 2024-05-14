At the current stage nothing has happened yet. We have just created a new project and initialized it. Let's now apply the configuration to create the file `hello.txt`.

## Tasks

* Before anything is done, you should review the changes that will be made to your infrastructure. This is done by running the `plan` command:

```shell
tofu plan
```{{exec}}

As you can see, the plan indicates that a new file `hello.txt` should be created. We have certain attributes which are not yet known, because the object does not yet exist on the system.

* Export the plan to a file called `/root/hello-example.plan`, this can be done just with `tofu`. Review the possible arguments for `tofu`:

```shell
tofu plan -h
```{{exec}}

Saving a plan to a file is the recommended way to ensure that the plan is reviewed and approved before applying it. Otherwise there might be changes applied that were not intended. If the plan is in a file which is no longer changes, no more changes from the project can influence the plan.


* You may want to check the content of the plan file, however it's in binary format and really not human readable. You can use the `show` command to see the content of the plan file.

```shell
tofu show /root/hello-example.plan
```{{exec}}

* Store the output of the `show` command in a file called `/root/hello-example.plan.txt`. This can be done by using the `>` operator in the shell.

```shell
tofu show /root/hello-example.plan > /root/hello-example.plan.txt
```{{exec}}

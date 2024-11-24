In the previous step, we saw that when you delete a file manually, the state notices its absence on a refresh (plan) operation, and it is recreated on the next application. Let's look at other scenarios where you might have conflicts between the desired and actual states. 

## Tasks

Complete these tasks for this step:

### Task 1: State conflict

We want to simulate a situation where the file `morning.txt` is already present on a machine but not in our state. Create the file:

```shell
cat  > morning.txt <<EOF
Hello, World!
EOF
```{{exec}}

Our state currently does not know about the file `morning.txt`. You can verify this by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

Now, we are expecting to get a conflict when running:

```shell
tofu plan && tofu apply
```{{exec}}

🤔 ... It just recreated the file?

See, that's the thing with the [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) provider. It has special behavior because OpenTofu is not really intended to manage local files but for Cloud infrastructure. The documentation for file resources states:

> The path to the file that will be created. Missing parent directories will be created. If the file already exists, it will be overridden with the given content.

We can't show an imported example with this provider. However, this should teach you that each provider has different aspects and gotchas. The provider documentation is your best friend. 

We'll be looking into provider specific behavior in the provider step.

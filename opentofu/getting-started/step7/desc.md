We have seen in the previous step, that when you delete a file manually, the state notices it's absence on a refresh (plan) operation and on the next apply it is recreated. Let's look at other scenarios where you might have conflicts between desired and actual state. 

## Tasks

Complete these tasks for this scenario.

### Task 1: State Conflict

The capability to import state is crucial when you have an existing infrastructure that you want to manage with OpenTofu. This is a common scenario when you are migrating from another infrastructure as code tool or when you have manually created resources.

We want to simulate a situation, where the file `morning.txt` is already present on a machine but not in our state. Create the file:

```shell
cat  > morning.txt <<EOF
Hello, World!
EOF
```{{exec}}

Our state currently does not know about the file `morning.txt`. You can verify this by running the `state ls` command:

```shell
tofu state ls
```{{exec}}

Now we are expecting to get a conflict when running:

```shell
tofu plan & tofu apply
```{{exec}}

🤔 ... It just recreated the file?

See that's thing with the [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) provider. It has special behavior because Opentofu is not really intended to manage local files but for Cloud infrastructure. The documentation for file resources states:

> The path to the file that will be created. Missing parent directories will be created. If the file already exists, it will be overridden with the given content.

So we can't you show an import example with this provider. However this should teach you, each Provider has different aspects and gotchas. The Provider documentation is your best friend. 

We'll be looking into Provider specific behavior in the provider scenario.




  
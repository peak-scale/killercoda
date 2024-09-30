The *destroy* command removes all resources that OpenTofu manages. It is helpful for cleaning up your infrastructure or starting from scratch.

## Tasks

Complete these tasks for this step:

### Task 1: Destroy all resources

> [Documentation](https://opentofu.org/docs/cli/commands/destroy/)

For further steps, we need all the files to be absent. We can remove it by running the `apply -destroy` (or `tofu destroy`) command:

```shell
tofu apply -destroy
```{{exec}}

**Note**: do confirm by typing `yes`. This command destroys all resources that are managed by OpenTofu, so be careful when using it.

## Destroying one resource

> This is an advanced topic and does not require any further steps from your side. It's good enough if you are aware of the option.

Another approach is to destroy a specific resource however this is only used in exceptional situations (recovery). 

* For this, we need to create a plan file that is limited to the resource we want to destroy. 

```shell
 tofu plan -target="local_file.example" -out /root/destroy-plan
```{{exec}}

If you are unsure about the target name, you can look at your current state:

```shell
tofu state ls
```{{exec}}

Now you can destroy the resource by running the `apply` command with the plan file:

```shell
tofu apply -destroy "/root/destroy-plan"
```{{exec}}

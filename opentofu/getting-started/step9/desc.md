Working with the state is the key aspect when it comes to consistency. It's not ideal to have the state stored locally.

## Tasks

Complete these tasks for this step.

### Task 1: View the state file

Since we use the default configuration, the state is written into a file called `terraform.tfstate` in the working
directory. In a production environment, you would store the state somewhere else, like in a remote backend.

```shell
ls -l ~/scenario/terraform.tfstate
```{{exec}}

The state contains sensitive information (if your configuration contains secrets) and should not be published or shared.

### Task 2: Remove the state file

Remove the state file (don't do this elsewhere 😄):

```shell
rm -f ~/scenario/terraform.tfstate
```{{exec}}

Now that we have lost the state, it's unclear to OpenTofu what's already managed by it and what's not. Essentially, you
start from scratch and need to import or recreate all the resources. Losing the state is not an advisable for large
infrastructures (data loss 🔥):

```shell
tofu state ls
```{{exec}}

### Task 3: Backup 🚒

You should always have a backup of your state, no matter where it's stored:

```shell
cp  ~/scenario/terraform.tfstate.backup ~/scenario/terraform.tfstate
```{{exec}}

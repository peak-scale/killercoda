Working with state is the key aspect when it comes to consistency. It's not ideal to have the state just locally. However in our case we have a file called.

## Tasks

Complete these tasks for this scenario.

### Task 1: View Statefile

Since we are using the default configuration, the state is written into a file called `terraform.tfstate` in the working directory. In a production environment you would have the state somewhere else, like in a remote backend.

```shell
ls -l ~/scenario/terraform.tfstate
```{{exec}}

The state contains sensitive information (if your configuration contains secrets) and should not be published or shared.


### Task 2: Remove Statefile

Remove the state file (Don't do this elsewhere :D):

```shell
rm -f ~/scenario/terraform.tfstate
```{{exec}}

Now that we have lost the state, it's unclear to Opentofu what's already managed by it and what's not. Essentially you start from scratch and can either import all the resources or recreate them. But that's not gonna be an option for large infrastructures (Data Loss 🔥):

```shell
tofu state ls
```{{exec}}

### Task 3: Backup 🚒

That shows you, always have a backup of your state, no matter where it's stored:

```shell
cp  ~/scenario/terraform.tfstate.backup ~/scenario/terraform.tfstate
```{{exec}}

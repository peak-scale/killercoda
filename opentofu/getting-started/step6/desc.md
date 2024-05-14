Destroying resources is used when you want to remove all resources that are managed by Opentofu. This is useful when you want to clean up your infrastructure or when you want to start from scratch.

# Tasks

* For further steps, we need all the files to be absent. We can remove it by running the `apply -destroy` (or `tofu destroy`) command:
   
```shell
tofu apply -destroy
```{{exec}}

**Note**: do confirm by typing `yes`. This command destroys all resources that are managed by Opentofu, so be careful when using it.

## Destroying one Resource

Another approach is to destroy a specific resource, however this is only used in exceptional situations (recovery). 

* For this we need to create a plan file which is limited to the resource we want to destroy. 

```shell
 tofu plan -target="local_file.example" -out /root/destroy-plan
```{{exec}}

if you are unsure about the target name, you can look at your current state

```shell
tofu state ls
```{{exec}}

* Now you can destroy the resource by running the `apply` command with the plan file:

```shell
tofu apply -destroy "/root/destroy-plan"
```{{exec}}


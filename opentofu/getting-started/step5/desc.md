This demonstrates one of the key aspects of why state makes sense. It's always known which resources should and how they should exist. The same goes for resources which should no longer exist. In comparison to eg. Ansible, Terraform is able to destroy resources which are no longer part of the configuration.

# Tasks

* Now we are adding a second file to the configuration:
   
```shell
cat <<EOF > local_file.tf
resource "local_file" "goodbye" {
    filename = "\${path.module}/goodbye.txt"
    content  = "Goodbye, Terraform!"
}
EOF
```{{exec}}

The name of the resource must be different (`goodbye`) to avoid conflicts.

> We can place any `*.tf` file in the configuration directory. Terraform will automatically detect and apply the configuration. However you can't use subdirectories.

* Plan and Apply the changes, you may review what's being created:

```shell
tofu plan && tofu apply -auto-approve
```{{exec}}

* Verify the new file was created:

```shell
cat ./goodbye.txt
```{{exec}}

* Let's make changes to the content and the name of the file. We'll also change the resource's name to `morning`:

```shell
cat <<EOF > local_file.tf
resource "local_file" "morning" {
    filename = "\${path.module}/morning.txt"
    content  = "Good Morning, Terraform!"
}
EOF
```{{exec}}

* Plan the changes. You should see that the file `goodbye.txt` will be removed and `morning.txt` will be created:

```shell
tofu plan
```{{exec}}

You should see that the file `goodbye.txt` will be removed and `morning.txt` will be created. So you don't have to worry about the removal of the old file, Terraform will take care of it. This Garbage Collection is possible because of the state file. Apply the changes:

```shell
tofu apply -auto-approve
```{{exec}}
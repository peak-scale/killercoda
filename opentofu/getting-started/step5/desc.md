This step demonstrates one of the key aspects of why having a state makes sense. Thanks to it, it's always known which
resources should exist and how they should exist and which resources should no longer exist. Compared to Ansible,
OpenTofu can destroy resources that are no longer part of the desired configuration.

## Tasks

Complete these tasks for this step:

### Task 1: Extend Configuration

> We can place any `*.tf` file in the configuration directory. OpenTofu will automatically detect and apply the
configuration. However, you can't use subdirectories.

Now, we are adding a second file to the configuration:

```shell
cat <<EOF > local_file.tf
resource "local_file" "goodbye" {
    filename = "\${path.module}/goodbye.txt"
    content  = "Goodbye, OpenTofu!"
}
EOF
```{{exec}}

The **local name** of the resource must be different (`goodbye`) to avoid conflicts.

Plan and apply the changes, you may review what's being created:

```shell
tofu plan
```{{exec}}

```shell
tofu apply -auto-approve
```{{exec}}

Verify that the new file was created:

```shell
cat goodbye.txt
```{{exec}}

### Task 2: Change content

Let's make changes to the content and the name of the file. We'll also change the resource's name to `morning`:

```shell
cat <<EOF > local_file.tf
resource "local_file" "morning" {
    filename = "\${path.module}/morning.txt"
    content  = "Good Morning, OpenTofu!"
}
EOF
```{{exec}}

Plan the changes. You should see that the file `goodbye.txt` will be removed and `morning.txt` will be created:

```shell
tofu plan
```{{exec}}

You don't have to worry about the removal of the old file, OpenTofy will take care of it. This kind of "Garbage Collection"
is possible because the state file tracks the resources. Now you can apply the changes:

```shell
tofu apply -auto-approve
```{{exec}}

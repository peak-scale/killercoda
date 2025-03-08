OpenTofu is an infrastructure as code tool that lets you define both cloud and local resources.

At this point you can consider that a *project* is a directory which contains the configuration files for your
infrastructure and possibly the state of your infrastructure.
The directory is the basic unit of configuration in OpenTofu, all the files in it are part of the same configuration,
so you can imagine that all the files are merged into one during the execution of OpenTofu.

Before starting, it's important to introduce the idea that there are three "configurations" existing at the same time:
- the configuration written in the code, sometimes called desired state;
- the configuration written in the [state](https://opentofu.org/docs/language/state/) file (named `terraform.tfstate`),
which is produced by OpenTofu and contains the created resources;
- the provisioned configuration consisting of the actual resources created.

## Tasks

Complete these tasks for this step:

### Task 1: First main.tf

Create a new file called `main.tf`. The file name does not matter, but it is a common convention to name the main
configuration file `main.tf`. As long as your file has a `.tf` extension in the current directory, Terraform will
recognize it as a configuration file. This does not work for subdirectories.

```shell
cat <<EOT > main.tf
terraform {
    required_providers {
        local = {
            source  = "hashicorp/local"
            version = "2.5.2"
        }
    }
}

provider "local" {
}

resource "local_file" "example" {
    filename = "\${path.module}/hello.txt"
    content  = "Hello, OpenTofu!"
}
EOT
```{{exec}}

This configuration does the following:
- The first block declares the required provider, [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs), which
is used for managing local resources. More in general a [provider](https://opentofu.org/docs/language/providers/) is a
plugin for OpenTofu that allows OpenTofu to interact with cloud providers, SaaS providers and other APIs.
- The second block configures the [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
provider, but no additional configuration is necessary for this example.
- The third block defines a resource of type `local_file` named example. This resource creates a file named `hello.txt`
in the same directory as your Terraform configuration, containing the text "Hello, OpenTofu!".

### Task 2: Initialize

The [initialization](https://opentofu.org/docs/cli/commands/init/) is the first phase/step of the OpenTofu workflow, it
mainly does three things:
- read the `.tf` files in the root directory, looking for the
[backend configuration](https://opentofu.org/docs/language/settings/backends/configuration/) which specify where to put
the state file.
- read the `.tf` files in the root directory, looking for the
[module](https://opentofu.org/docs/language/modules/develop/) blocks to download/copy (modules are simply containing
additional configuration and are used for creating abstractions i.e. boundle and reuse code).
- read the `.tf` files in the root directory, looking for the provider blocks to download and configure.


Initialize the configuration:

```shell
tofu init
```{{exec}}

The other phases of the OpenTofu workflow, which will be presented in the next steps, are plan and apply.

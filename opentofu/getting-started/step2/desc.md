A Project in this scenario is a directory. Essentially with Opentofu you store relevant files in a directory. The directory is the basic unit of configuration in Opentofu. The directory contains all the configuration files for your infrastructure and may even include the state.

## Tasks

Complete these tasks for this scenario.

## Task 1: First `main.tf`

Create a new file called `main.tf`. The file name does not matter, but it is a common convention to name the main configuration file `main.tf`. As long as your file has a `.tf` extension in the current directory, Terraform will recognize it as a configuration file. This does not work for subdirectories.

```shell
cat <<EOT > main.tf
terraform {
    required_providers {
        local = {
            source = "hashicorp/local"
        }
    }
}

provider "local" {
}

resource "local_file" "example" {
    filename = "\${path.module}/hello.txt"
    content  = "Hello, Terraform!"
}
EOT
```{{exec}}

This configuration does the following:

  - It declares a required provider, [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs), which is used for managing local resources.
  - The provider block configures the [local](https://registry.terraform.io/providers/hashicorp/local/latest/docs) provider. No additional configuration is necessary for this example.
  - The resource block defines a resource of type local_file named example. This resource creates a file named hello.txt in the same directory as your Terraform configuration, containing the text "Hello, Terraform!".

## Task 2: Initialize

Initialize the configuration:

```shell
tofu init
```{{exec}}

This command will initialize the project and download the required providers. An internet connection is required to download the providers.
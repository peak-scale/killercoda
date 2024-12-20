A Project in this scenario is a directory. Essentially with OpenTofu you store relevant files in a directory. The directory is the basic unit of configuration in OpenTofu. The directory contains all the configuration files for your infrastructure and may even include the state.

### Initialize OpenTofu Project

1. Create a new directory for your project:

```shell
mkdir tofu-example
cd tofu-example
```

2. Now create a new file called `main.tf`:

```shell
terraform {
    required_providers {
        local = {
            source = "hashicorp/local"
        }
    }
}

provider "local" {
    # Configuration options
}

resource "local_file" "example" {
    filename = "${path.module}/hello.txt"
    content  = "Hello, Terraform!"
}
```

This configuration does the following:

* It declares a required provider, local, which is used for managing local resources.
The provider block configures the local provider. No additional configuration is necessary for this example.
The resource block defines a resource of type local_file named example. This resource creates a file named hello.txt in the same directory as your Terraform configuration, containing the text "Hello, Terraform!".

3. Initialize the OpenTofu Project:

```shell
tofu init
```{{exec}}

This command will initialize the project and download the required providers. An internet connection is required to download the providers.

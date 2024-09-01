We are going to migrate the state from a local file to a Kubernetes secret.

# Tasks

* Initialize a new project using with the following OpenTofu configurations:

```shell
main.tf
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
    filename = "\${path.module}/hello.txt"
    content  = "Hello, Terraform!"
}
EOT
```{{exec}}



1. Add OpenTofu Keyring:
   
```shell
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```{{exec}}

2. Add OpenTofu Package Repository:

```shell
echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
  sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```{{exec}}

3. Install OpenTofu:

```shell
sudo apt-get update
sudo apt-get install -y tofu
```{{exec}}

Verify the installation by running:

```shell
tofu -version
```{{exec}}

Before starting this scenario, you need to install OpenTofu on the given environment. See for reference the [official website](https://opentofu.org/docs/intro/install/https://opentofu.org/docs/intro/install/). You can use the same process to install opentofu on your local machine.

The [OpenTofu CLI](https://opentofu.org/docs/intro/install/) interacts with the state and executes everything in our scenarios.

## Tasks

On this environment we are running [Ubuntu](https://opentofu.org/docs/intro/install/deb/), so we can use the following commands to install OpenTofu.

- Add OpenTofu Keyring:

```shell
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```{{exec}}

 - Add OpenTofu Package Repository:

```shell
echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
  sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```{{exec}}

 - Install OpenTofu:

```shell
sudo apt-get update
sudo apt-get install -y tofu
```{{exec}}

 - Verify the installation by running:

```shell
tofu -version
```{{exec}}

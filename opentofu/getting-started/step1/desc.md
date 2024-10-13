Before starting this step, you must install OpenTofu in the given environment. For reference, see the [official website](https://opentofu.org/docs/intro/install/). You can use the same process to install OpenTofu on your local machine.

The [OpenTofu CLI](https://opentofu.org/docs/intro/install/) interacts with the state and executes everything in our scenarios.

## Tasks

In this environment, we are running [Ubuntu](https://opentofu.org/docs/intro/install/deb/), so we can use the following commands to install OpenTofu:

### Task 1: Add OpenTofu keyring

```shell
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```{{exec}}

### Task 2: Add package repository

```shell
echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
  sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```{{exec}}

### Task 3: Install OpenTofu

```shell
sudo apt-get update
sudo apt-get install -y tofu
```{{exec}}

### Task 4: Verify the installation

```shell
tofu -version
```{{exec}}

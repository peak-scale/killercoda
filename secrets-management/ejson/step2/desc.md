# Tasks

Change into the existing infrastructure directory:

```shell
cd ~/infrastructure
```{{exec}}

---

Create a new file called `provider.tf` in the current directory which uses the provider [hashicorp/kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest). The provider should be version `2.30.0`. For the configuration of the provider use:

```shell
provider "kubernetes" { 
  config_path = "~/.kube/config"
}
```{{copy}}

With this configuration we declare, that we want to use the kubeconfig located at `~/.kube/config` to connect to the Kubernetes cluster. This is the default location where the kubeconfig is stored.

---

If your provider configuration is correct, you can initialize the project by running:


```shell
tofu init
```{{exec}}

With this interaction, you will initialize the project and download the required providers.

--- 

Verify the providers being used in your project by running:

```shell
tofu providers
```{{exec}}

You should see the following output:

```shell
Providers required by configuration:
.
└── provider[registry.opentofu.org/hashicorp/kubernetes] 2.30.0
```

# Check

> If the verification was not successful and you are unsure what the problem is, review the  `~/.solutions/step2/provider.tf` file.

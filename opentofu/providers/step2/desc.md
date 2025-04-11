Now you know how to navigate providers and look up information that is relevant to setting up providers in your
configuration. In the following tasks, you will start working with providers.

# Tasks

Complete these tasks for this scenario.

## Task 1: Define Provider

Create a new file called `provider.tf` in the `~/scenario` directory, which uses the
provider [hashicorp/kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest). The provider
should be version `2.30.0`. The provider must be configured to use the config located at `"~/.kube/config"`.

## Task 2: Initialize Provider

If your provider configuration is correct, you can initialize the project and download the providers by running the following:

```shell
tofu init
```{{exec}}

## Task 3: Verify Provider

Verify the providers used in your project by running:

```shell
tofu providers
```{{exec}}

You should see the following output:

```shell
Providers required by configuration:
.
└── provider[registry.opentofu.org/hashicorp/kubernetes] 2.30.0
```

# Verify

> If the verification was not successful (the check button) and you are unsure what the problem is, review the solution
> generated in `~/.solutions/step2/`. You can always copy the solution files to the current working directory by
> running `cp ~/.solutions/step2/* ~/scenario/`{{copy}}.

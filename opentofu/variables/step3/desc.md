Let's explore an implementation, where the variables are offloaded to a dedicated file.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Variable Files

Create a file called `prod.tfvars` in your working directory. Within this file, define the following variables:

```hcl
environment = "prod"
labels = {
  "app" = "production"
  "required-approval" = "true"
}
```{{copy}}

Create a file called `test.tfvars` in your working directory. Within this file, define the following variables:

```hcl
environment = "test"
labels = {
  "app" = "pre-prod"
  "required-approval" = "false"
}
```{{copy}}

## Task 2: Add Variables

To the existing `variables.tf` add a new variable:

  * `labels`:
    * `description`: `"Additional labels for the resources"`{{copy}}
    * `type`: `map(string)`{{copy}}
    * `default`: `{}`{{copy}}

## Task 3: Use Variable

These annotations should be used in the `kubernetes_namespace_v1` resources in the `kubernetes.tf`. Assign it to the `metadata` block in the for the `labels` attribute:

```shell
resource "kubernetes_namespace_v1" "namespace" {
  ...
  metadata {
    ...
    labels = HERE
  }
}
```

## Task 3: Use Variable File

> `tofu plan -h`{{execute}} might help here.

Use the variable file `prod.tfvars` to **apply** the changes.

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step3/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step3/* ~/scenario/`{{copy}}.


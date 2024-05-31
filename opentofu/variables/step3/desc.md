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
```

Create a file called `test.tfvars` in your working directory. Within this file, define the following variables:

```hcl
environment = "test"
labels = {
  "app" = "pre-prod"
  "required-approval" = "false"
}
```

## Task 2: Add Variables

To the existing `variables.tf` add a new variable:

  * `labels`:
    * `description`: Additional labels for the resources 
    * `type`: `map(string)`
    * `default`: `environment = var.environment`

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

Use the file `prod.tfvars` to create a plan and **apply** the changes with these variables. You should see changes, but your plan seems up to date. Probably the `prod.tfvars` is not loaded. 

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step3/`.



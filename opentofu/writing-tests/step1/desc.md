One aspect of variables is the possibility to reference attributes of resource blocks in the same module. Resources provide often read only attributes that can be used in other resources. This is a powerful feature to build generic and reusable configurations.

To access these attributes you can use the following syntax:

```hcl
<RESOURCE TYPE>.<NAME>.<ATTRIBUTE>
```
Reusing attributes from resource blocks keeps your configuration DRY (Don't Repeat Yourself) and makes it easier to maintain.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Review `kubernetes.tf`

There's a file located in your working directory called `kubernetes.tf`. Review the content of the file. 

```shell
cat kubernetes.tf
```{{execute}}

You will notice that there are redundant values in the configuration:

* `prod-environment`: The namespace name is used in multiple resources.
* `prod-sa`: The service account name is used in multiple resources.

## Task 2: Implement Resource Attribute References

Rewrite the file `kubernetes.tf` to use the resource attributes instead of hardcoding the values. This is how you can reference the attributes:

* `kubernetes_namespace_v1.namespace.metadata.0.name` for the namespace name.

* `kubernetes_service_account_v1.serviceaccount.metadata.0.name` for the serviceaccount name.

> You can just replace the values with the resource attributes, no further changes to the file are required.

## Task 3: Review

If you now run the `plan` command, you should see that the configuration is still valid and nothing changed, where we replaced the values with the resource attributes.

> You might have updates regarding pod annotations, which are not relevant.

```shell
tofu plan
```{{execute}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the `~/.solutions/step1/kubernetes.tf` file.


One aspect of variables is the possibility to reference attributes of resource blocks in the same module. Resources provide often read only attributes that can be used in other resources. This is a powerful feature to build generic and reusable configurations.

To access these attributes you can use the following syntax:

```hcl
<RESOURCE TYPE>.<NAME>.<ATTRIBUTE>
```

Reusing attributes from resource blocks keeps your configuration DRY (Don't Repeat Yourself) and makes it easier to maintain.

> When referencing attributes, don't use quotes (`"` or `'`). Otherwise it will be interpreted as a `string`.

---

# Tasks

Complete these tasks for this scenario.

## Task 1: Review `scenario/kubernetes.tf`

There's a file called `scenario/kubernetes.tf`. Review the content of the file. You will notice that there are redundant values in the configuration:

* `dev-environment`: The namespace name is used in multiple resources.
* `dev-sa`: The service account name is used in multiple resources.

## Task 2: Implement Resource Attribute References

Rewrite the file `scenario/kubernetes.tf` to use the resource attributes instead of hardcoding the values. This is how you can reference the attributes (**where possible ;)**:

* `kubernetes_namespace_v1.namespace.metadata.0.name` for the namespace name.

* `kubernetes_service_account_v1.serviceaccount.metadata.0.name` for the serviceaccount name.

> You can just replace the values with the resource attributes, no further changes to the file are required.

## Task 3: Review

If you now run the `plan` command, you should see that the configuration is still valid and nothing changed, where we replaced the values with the resource attributes.

```shell
tofu plan
```{{execute}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step2/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step2/* ~/scenario/`{{copy}}.

# The missing `group_by`

In this section, you'll learn how to group objects by one of their fields.

```hcl
locals {
  employees = {
    Pam  = {manager = "",    project = "A"}
    Pete = {manager = "Pam", project = "A"}
    Joe  = {manager = "Pam", project = "B"}
  }
}
```{{copy}}

Given the example above we want to group the employees by their project. While it's possible to do by extracting the
projects and building the lists of employee that are working on that project with for loops and if, there is a simpler
way: using the ellipsis (...) for
[grouping results](https://opentofu.org/docs/language/expressions/for/#grouping-results).

```hcl
output "employees_by_project" { 
  value = {
    for person, details in local.employees : details.project => person...
  }
}
```{{copy}}

Without the ellipsis the above code would fail since the key in the expression is not unique across the element of the
result. However, the ellipsis will merge the key-value pairs by the key and produce a map of lists.

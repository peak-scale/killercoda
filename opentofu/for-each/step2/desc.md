## `count` vs `for_each`

Before `for_each` was available, `count` was used to look up the original list value:

```hcl
variable "subnet_ids" {
  type = list(string)
}

resource "aws_instance" "server" {
  count = length(var.subnet_ids)

  ami       = "ami-a1b2c3d4"
  subnet_id = var.subnet_ids[count.index]

  tags = {
    Name = "Server ${count.index}"
  }
}
```{{copy}}

> This was fragile, because the resource instances were still identified by their index instead of the string values in
> the list. If an element was removed from the middle of the list, every instance after that element would see its
> subnet_id value change, resulting in more remote object changes than intended. Using for_each gives the same flexibility
> without the extra churn [opentofu.org](https://opentofu.org/docs/language/meta-arguments/count/#when-to-use-for_each-instead-of-count).

Let's unpack the previous citation with an example that you can run. Create a file with the following content.

```hcl
locals {
  simple_list = ["a", "b", "c", "z"]
}

resource "terraform_data" "example" {
  count = length(local.simple_list)
  input = local.simple_list[count.index]
}
```{{copy}}

You do the `tofu apply` and everything looks great, until one day "b" is not needed anymore.

```hcl
locals {
  simple_list = ["a", "c", "z"]
}

resource "terraform_data" "example" {
  count = length(local.simple_list)
  input = local.simple_list[count.index]
}
```{{copy}}

You exec the `tofu plan` and discover `Plan: 0 to add, 2 to change, 1 to destroy.` The order of the list changed, now
the resource belonging to the 3rd item in the list belongs to the 2nd item in the list, as the 4th is now on the 3rd
place: the slice of the list after the "b" is getting shifted on the left. In this case the resources are getting modified,
in some other cases the affected resources could be destroyed and recreated.

If the temporary changes are acceptable you can just apply otherwise you'll need to use the
[state mv](https://opentofu.org/docs/cli/commands/state/mv/#example-move-a-resource-into-a-module) command or the
[moved](https://opentofu.org/docs/language/modules/develop/refactoring) block.

To avoid these isssues use the `for_each` with the `toset()` function. The conversion from list to set is needed
because the `for_each` uses the elements of a setas key for the resources as a consequence those keys need to be unique.

```hcl
locals {
  simple_list = toset(["a", "b", "c", "z"])
}

resource "terraform_data" "example" {
  for_each = local.simple_list
  input    = each.key
}
```{{copy}}

You can add and remove any element from the set and the changes will always be limited to the truly affected resource.
In conclusion it's better to use `for_each` in the majority of cases.

# `count` and `for_each`

As you know, a resource or datasource is associated with one real infrastructure object (in case of module the concept is
the same). However, when you want to manage several similar objects without writing a separate block for each one, you
can use the `count` or `for_each` meta-argument.

## `count`

> The count meta-argument accepts a whole positive number (and expressions resulting in whole positive numbers), and
> creates that many instances of the resource or module. Each instance has a distinct
> infrastructure object associated with it, and each is separately created, updated, or destroyed
> when the configuration is applied. [opentofu.org](https://opentofu.org/docs/language/meta-arguments/count/)

To access the index number you use the `count.index` (starting at 0) as shown below.


```hcl
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances

  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```{{copy}}

**Note**: since the `count` argument is needed for determining how many resources to create in the plan, the value must
be known before OpenTofu performs any remote resource actions. Otherwise, you'll have to split the plan either with
[workspaces](https://opentofu.org/docs/language/state/workspaces/) or with the `--target` option.


## `for_each`

> The for_each meta-argument accepts a map or a set of strings, and creates an instance for each item in that map or
> set. Each instance has a distinct infrastructure object associated with it, and each is separately created, updated,
> or destroyed when the configuration is applied. [opentofu.org](https://opentofu.org/docs/language/meta-arguments/for_each/)

In the blocks with `for_each` you can use the `each` object in expressions, the object has two attributes:
- `each.key` contains the key of the map of the current iteration or the member of the set,
- `each.value` contains the value of the map of the current iteration, if we're looping on a set the value is the same 
  as `each.key`. 

An example of the map and set of strings shown in the next code snippet.

```hcl
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group       = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}

resource "aws_iam_user" "accounts" {
  for_each = toset(["Todd", "James", "Alice", "Dottie"])
  name     = each.key
}
```{{copy}}

**Note**: as in the count case the value must be known before OpenTofu performs any remote resource actions. Otherwise,
you'll have to split the plan either with
[workspaces](https://opentofu.org/docs/language/state/workspaces/) or with the `--target` option. More considerations
on [opentofu.org](https://opentofu.org/docs/language/meta-arguments/for_each/#limitations-on-values-used-in-for_each).

For those that are wondering why the `toset` function was used in the example, here is a short recap. Opentofu and
Terraform are typed languages, this means that all values have a type which define where that value can be used and what
operations can be applied to it. The OpenTofu language has various types: `string`, `number` (both integers and
reals), `bool`, `list`, `set`, `map`. The last three types are the ones that require a discussion.
A `list` is an ordered sequence of values, the elements of a `list` are identified by consecutive whole numbers,
starting with zero; this means that we can have duplicate elements since they are identified by their index.
A `set` is a collection of unique values without order or any other secondary identifiers, each element is identified by
their value, this means that a `set` cannot have duplicate elements.
A `map` is a group of values identified by unique named labels.

Since the `for_each` uses the elements of a set as key for the resources, those keys need to be unique, which means that
the `for_each` expression cannot be a `list` but a `set` is accepted.

More on the type system at [opentofu.org](https://opentofu.org/docs/language/expressions/types/) and
[hashicorp.com](https://developer.hashicorp.com/terraform/language/expressions/type-constraints).

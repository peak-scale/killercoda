# The for_each index p2

In the case of map/object the for loop iterates on a single level, but sometimes we want to iterate on multiple nested
items. In the example below, given the availability zone and the CIDRs we want to create the subnets with the for loop
and have human-readable indexes.

```hcl
locals {
  subnets = {
    az1 = ["10.0.1.0/24", "10.0.2.0/24"]
    az2 = ["10.0.10.0/24", "10.0.11.0/24"]
    az3 = ["10.0.20.0/24", "10.0.21.0/24"]
  }
  
  desired_output = {
    "az1-10.0.1.0/24" = "10.0.1.0/24"
    "az1-10.0.2.0/24" = "10.0.2.0/24"
    # etc
  }
}

output "first_try" {
  value = {
    for az, subnet_list in local.subnets: {
      for subnet in subnet_list: "${az}-${subnet}" => subnet
    }
  }
}
```{{copy}}

Unfortunately the first try fails since the external for loop tries to build an object and requires a key-value
expression but the subnet part of the key is not available in the external loop, only in the internal one. 

```bash
│ Error: Invalid 'for' expression
│ 
│   on main.tf line 8, in locals:
│    7:   result = {
│    8:     for az, subnet_list in local.subnets: {
│    9:       for subnet in subnet_list: "${az}-${subnet}" => subnet
│   10:     }
│   11:   }
│ 
│ Key expression is required when building an object.
```

Luckily, this is one of the cases where playing around is rewarded, if you simply avoid the problem by using the `[]`
you get the following:

```hcl
output "second_try" {
  value = [
    for az, subnet_list in local.subnets: {
      for subnet in subnet_list: "${az}-${subnet}" => subnet
    }
  ]
}
```{{copy}}

```text
Changes to Outputs:
  + second_try = [
      + {
          + "az1-10.0.1.0/24" = "10.0.1.0/24"
          + "az1-10.0.2.0/24" = "10.0.2.0/24"
        },
      + {
          + "az2-10.0.10.0/24" = "10.0.10.0/24"
          + "az2-10.0.11.0/24" = "10.0.11.0/24"
        },
      + {
          + "az3-10.0.20.0/24" = "10.0.20.0/24"
          + "az3-10.0.21.0/24" = "10.0.21.0/24"
        },
    ]
```

Given this intermediate result how do we merge the elements of the list?
The [merge](https://opentofu.org/docs/language/functions/merge/) function does not accept a list.

The secret sauce is the ellipsis expansion symbol (...)
[opentofu](http://opentofu.org/docs/language/expressions/function-calls/#expanding-function-arguments) which transforms
the list in separate arguments.

```hcl
locals {
  intermediate_result = [
    for az, subnet_list in local.subnets: {
      for subnet in subnet_list: "${az}-${subnet}" => subnet
    }
  ]
  
  result = merge(local.intermediate_result...)
}
```{{copy}}

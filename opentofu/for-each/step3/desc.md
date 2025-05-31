# The for_each index

Sometimes you will encounter a list of objects/maps that you want to pass to the `for_each`, but that is not possible
because the supported types are maps and set of strings. However, this case is solvable by deciding which field should
act as key, for example we can use "name" if unique:

```hcl
locals {
  list_of_images = [{
    name  = "busybox"
    image = "busybox:latest"
  },{
    name  = "alpine"
    image = "alpine:latest"
  },{
    name  = "bash"
    image = "bash:latest"
  }]
  
  # the result that we want
  map_of_images_with_name_key = {
    busybox = {
      name  = "busybox"
      image = "busybox:latest"
    }
    alpine = {
      name  = "alpine"
      image = "alpine:latest"
    }
    bash = {
      name  = "bash"
      image = "bash:latest"
    }
  }
}
```{{copy}}

Now that the desired result was written we can notice that: the internal objects/maps are preserved (not useful in this
case but needed in others) and the type of the result is not a list/set anymore but an object/map. The change can be
done with the following for loop.

```hcl
{ for image in local.list_of_images: image.name => image }
```{{copy}}

> [Documentation](https://opentofu.org/docs/language/data-sources/#multiple-resource-instances).

Data sources can also work on iterations. We'll implement the example with the `count` meta-argument. But it can also be used with `for_each` meta-argument. You have two new files in your working directory:

* `locals.tf` - Contains the variable `replicas` with the value `3`.
* `pods-count.tf` - Contains the resource `kubernetes_pod_v1` with the `count` meta-argument.

These files create pods based on the value of `local.replicas`.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Implement `count`

> [Documentation](https://opentofu.org/docs/language/meta-arguments/count/)

https://opentofu.org/docs/language/meta-arguments/count/

Create a new file called `count-sources.tf`. Create a new data source for `kubernetes_pod_v1` with the `count` meta-argument. The resource must be called `workload_info`. 

  * Use the `count` uses the value of `local.replicas`.
  * To reference the pod `name`, use the local resource reference with a count index (e.g. `kubernetes_pod_v1.count-workload[count.index]...`).
  * To reference the pod `namespace`, use the local resource reference with a count index (e.g. `kubernetes_pod_v1.count-workload[count.index]...`).

## Task 2: Add Output

We would like a new output called `pod_uids` in the `outputs.tf` file. The output should list the IP addresses of the pods created. Here's a starting point, however it's not yet complete:

```hcl
[for pod in data.kubernetes_pod.workload_info : ... ]
```

The IP of a pod can be access via the `metadata[0].uid` argument.

## Task 3: Apply

When you run `tofu apply`{{exec}} you should see the uids of the pods:

```shell
...
  + pod_uids = [
      + "a904147f-cad0-4091-b3bc-8be1d9800909",
      + "51dbd087-9c14-41e7-9709-86733acb570d",
      + "db9efefc-767c-4189-a928-5ea3f2ca6dce",
    ]
...
```{{exec}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step4/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step4/* ~/scenario/`{{copy}}.
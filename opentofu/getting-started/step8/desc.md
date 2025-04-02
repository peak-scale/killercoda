The capability to import a resource in the state is crucial when you have an existing infrastructure you want to manage
with OpenTofu. This is a common scenario when migrating from another infrastructure as code tool or when you have
manually created resources.

## Tasks

Complete these tasks for this step:

### Task 1: Review the setup

We have added the [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) provider to the
configuration. You may review the `main.tf` file:

```shell
cat ~/scenario/main.tf
```{{exec}}

We have added a file `kubernetes.tf`, which contains a simple Kubernetes resource:

```shell
cat ~/scenario/kubernetes.tf
```{{exec}}

### Task 2: Apply

Apply the new configuration, also note how all the files are being destroyed:

```shell
tofu apply -auto-approve
```{{exec}}

But now there's a conflict when confirming the `apply`:

```shell
│ Error: pods "nginx" already exists
│ 
│   with kubernetes_pod_v1.workload,
│   on kubernetes.tf line 1, in resource "kubernetes_pod_v1" "workload":
│    1: resource "kubernetes_pod_v1" "workload" {
```

We can verify that by looking at the actual infrastructure:

```shell
kubectl get pod nginx -n default
```{{exec}}

Indeed there's already a Pod with that name. Now come the hard questions:

* What is this resource, and where does it belong?
* Can I import (adopt) this resource, or should I destroy it?
* Should I rename my resource?

Always be aware of the implications of importing resources and if they make sense. Since we control that workload, we
want to adopt it into our state.

### Task 3: Import

> [Documentation](https://opentofu.org/docs/cli/commands/import/)

One solution to this would be to just delete the resource on the infrastructure and reapply the configuration. But we
want to adopt the resource into our state. Import adopts an existing resource into the state. Imagine migrating virtual
machines, which were manually created, into your state. That's where `import` comes in handy. With an import we are
manually declaring "yep, that resource in our state should be reflected on that actual resource".

We need to know under which local name we want to import the resource. Based on the above error, we know it's
`kubernetes_pod_v1.workload`.

Run the `import` command to import the resource in the state:

```shell
tofu import kubernetes_pod_v1.workload default/nginx
```{{exec}}

The import of a resource always depends on the provider and the resource. For this case, you can use this
[documentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_v1#import)

We can verify that the resource is now part of the state:

```shell
tofu state ls
```{{exec}}

### Task 4: Eventual consistency

The resource is now part of our state but the configuration on the infrastructure mismatches our configuration. Apply
the desired configuration to make the state consistent with the actual infrastructure.

```shell
tofu apply -auto-approve
```{{exec}}

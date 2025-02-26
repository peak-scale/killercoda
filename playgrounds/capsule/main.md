
# Capsule

You as an `Cluster Administrator` have already created some tenants you want to share with your `Users`. To verify, list all the available Tenants:

```shell
kubectl get tnt
```{{exec}}

Let's inspect the `solar` tenant more closely:

```shell
kubectl get tnt solar -o yaml
```{{exec}}

There's currently not much defined:

```yaml
spec:
  additionalRoleBindings:
  - clusterRoleName: tenant-viewer
    subjects:
    - kind: User
      name: bob
  cordoned: false
  ingressOptions:
    hostnameCollisionScope: Disabled
  limitRanges: {}
  networkPolicies: {}
  owners:
  - clusterRoles:
    - admin
    - capsule-namespace-deleter
    kind: User
    name: alice
  - clusterRoles:
    - admin
    - capsule-namespace-deleter
    kind: Group
    name: solar-users
  preventDeletion: false
  resourceQuotas:
    scope: Tenant
```

What's important are the entries under `.spec.owners`. There we can see we have granted the `User` `alice` and the `Group` `solar-users` [Ownership](https://projectcapsule.dev/docs/tenants/permissions/#ownership) of this tenant. From our point of view all these users are responsible to manage the tenant. The main difference is, that `Owners` can manage `Namespaces` within their tenant and grant more permissions to other users.

So how is now the tenant context evaluated? If we as administrators create a new namespace it's not assigned to any tenant, try it yourself:

```shell
kubectl create ns which-tenant
```{{exec}}

You can see that no tenant has increased their count:

```shell
kubectl get tnt
```{{exec}}

It makes sense, since the admin config was not declared in any tenant as owner. Therefor they are not regarded as tenant user. However since we are using cluster-admin priviliges, we have the right to create namespaces anyway. 

So let's impersonate `alice` and try to create a new namespace:

```shell
kubectl create ns solar-test --as alice
```{{exec}}

... Now we are getting a 403. What's now the problem?

**To very key concept** is in what `groups` the user has as attribute. Based on the group membership for the user, it's differenciated if a user is interacting with tenants or with the rest of the Kubernetes API directly.

This is declared in the CapsuleConfiguration:

```shell
kubectl get capsuleconfiguration -o yaml
```{{exec}}

Within the spec we can find, which groups are required to interact with tenants:

```shell
...
userGroups:
   - projectcapsule.dev
```
__info__: if you want to use serviceaccounts, you must add their namespace as group eg. `system:serviceaccounts:tenants-sas`

So let's try this again with also impersonating the group `projectcapsule.dev`:

```shell
kubectl create ns solar-test --as alice --as-group projectcapsule.dev
```{{exec}}

That seems to have worked, and it was directly assigned to the correct tenant.

```shell
kubectl get tnt solar
```{{exec}}

The same works for the group `solar-users`:

```shell
kubectl create ns solar-prod --as nobody --as-group projectcapsule.dev --as-group solar-users
```{{exec}}

Let's try to create another namespace:

```shell
kubectl create ns solar-dev --as alice --as-group projectcapsule.dev
```{{exec}}

Now we are exceeding the boundaries the `Cluster Adminsitrator` has defined on this tenant:

```shell
Error from server (Forbidden): admission webhook "namespaces.projectcapsule.dev" denied the request: Cannot exceed Namespace quota: please, reach out to the system administrators
```

Now the owners have to figure out themselves how they want to use their resources on their tenant.

If a user has multiple tenants assigned, the placement of the namespace must be explicit with a label. You can try it for `bob`, since he's owner of two tenants

```shell
kubectl create ns oily --as bob --as-group projectcapsule.dev

Error from server (Forbidden): admission webhook "owner.namespace.projectcapsule.dev" denied the request: Unable to assign namespace to tenant. Please use capsule.clastix.io/tenant label when creating a namespace
```

Correctly set the label to the correct tenant:

```shell
kubectl create -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    capsule.clastix.io/tenant: "oil"
  name: oily
EOF
```{{exec}}
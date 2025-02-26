
# Replications

[See Reference](https://projectcapsule.dev/docs/tenants/replications/)

From the perspective of an `Cluster Administrator`, we want to ensure certain resources are distributed amongst the namespaces of tenants. This way we can control basic ctrical tenancy.

If we look at [Networkpolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/), it's a core component of multi-tenancy. We should always isolate all the namespaces from tenants with a zero-trust networkpolicy. This way no communication amongst namespaces is possible.

Let's see if there are already any Networkpolicies:

```shell
kubectl get netpol -A 
```{{exec}}

Turns out there are already policies in the namespaces we just created:

```shell
solar-prod    zero-trust       <none>                        3m57s
solar-test    zero-trust       <none>                        3m58s
```

Looking at one, it does exactly what we are lookin to do:

```shell
kubectl get netpol zero-trust -n solar-prod -o yaml
```{{exec}}

This is thanks to [Replications/Resources](https://projectcapsule.dev/docs/tenants/replications/#globaltenantresource)

We have already created a replication in advance, which deploys this networkpolicy to all namespaces of the solar tenant, review it:

```shell
kubectl get GlobalTenantResource zero-trust-netpol -o yaml
```{{exec}}

`GlobalTenantResource` are a greate way to ensure namespaced objects or replicate one object to these namespaces. The resources are meant for `Cluster Administrators` to control their fleet of tenants and create the boundaries to their cluster, that they require.

## Tenant-Owner

As an `Tenant Owner` you might have the desire to distribute resources amongst all the namespaces in your tenant. This can be achieved with `TenantResource`. They are scoped to the tenant where they are created in.

Let's create a new docker pull secrets (pretend that's like a token from a harbor registry or something like that). You as `Tenant Owner` want to distribute that secret across your tenant. First create the secret.

```shell
kubectl create --as alice --as-group projectcapsule.dev -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: my-pullsecret
  namespace: solar-prod
  labels:
    distribute: "yes"
data:
  .dockerconfigjson: ewogICAgImF1dGhzIjogewogICAgICAgICJodHRwczovL2luZGV4LmRvY2tlci5pby92MS8iOiB7CiAgICAgICAgICAgICJhdXRoIjogImMzUi4uLnpFMiIKICAgICAgICB9CiAgICB9Cn0K
type: kubernetes.io/dockerconfigjson
EOF
```{{exec}}

Now let's create a `TenantResource` which replicates the secret to the other solar namespaces:

```shell
kubectl create --as alice --as-group projectcapsule.dev -f - <<EOF
apiVersion: capsule.clastix.io/v1beta2
kind: TenantResource
metadata:
  name: solar-pullsecret
  namespace: solar-prod
spec:
  resyncPeriod: 60s
  resources:
    - namespacedItems:
        - apiVersion: v1
          kind: Secret
          namespace: solar-prod
          selector:
            matchLabels:
              distribute: "yes"
EOF
```{{exec}}

After creating the `TenantResource` we can take a look at it:

```shell
kubectl get tenantresource -n solar-prod -o yaml
```{{exec}}

And we see the resource was successfully distributed to the other namespaces:

```shell
 kubectl get secret -A
```{{exec}}

# Enforcement

[See Reference](https://projectcapsule.dev/docs/tenants/enforcement/)

From the perspective of an `Cluster Administrator`, we want to ensure Tenants can only allocate certain Resources from our cluster.

We can update the tenant solar, that it only allows to usage of the selected PriorityClasses. If no PriorityClass is set, we can overwrite that on tenant basis before considering the cluster-wide default. Let's inspect the PriorityClasses intended for Customers:

```shell
kubectl get priorityclass -l consumer=customer
```

You can see best-effort is globaldefault, meaning it would be set by default.

Now we adjust the tenant `solar`, that only PriorityClasses with the label `consumer=customer` are allowed:

```shell
kubectl apply -f - <<EOF
---
apiVersion: capsule.clastix.io/v1beta2
kind: Tenant
metadata:
  name: solar
  labels:
    app.kubernetes.io/type: prod
spec:
  namespaceOptions:
    quota: 2
  owners:
  - name: alice
    kind: User
  - name: solar-users
    kind: Group
  additionalRoleBindings:
  - clusterRoleName: tenant-viewer
    subjects:
    - kind: User
      name: bob

  # This is new
  priorityClasses:
    default: "customer"
    matchLabels:
      consumer: "customer"
EOF
```{{exec}}

Great, now we try to schedule a new pod into `solar-prod`, using the priorityClass `system-node-critical` (which should not be used by tenants):


```shell
kubectl create --as alice --as-group projectcapsule.dev -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-node-critical
  namespace: solar-prod
spec:
  containers:
  - name: busybox
    image: busybox:latest
  priorityClassName: system-node-critical
EOF
```{{exec}}

That's being blocked! That's what we as Cluster Administrators expected. Let's try one, where we don't set the `priorityClassName`:

```shell
kubectl create --as alice --as-group projectcapsule.dev -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-default-priority
  namespace: solar-prod
spec:
  containers:
  - name: busybox
    image: busybox:latest
EOF
```{{exec}}

If we verify the priorityClass for the pod, it's set to the tenant default:

```shell
kubectl get pod pod-default-priority -n solar-prod -o jsonpath='{.spec.priorityClassName}'
```{{exec}}

With these same principles you can control all relevant scheduling of resources.
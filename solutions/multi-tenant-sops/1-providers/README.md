# SOPS Providers

The SopsProvider Custom Resource is essentially a connector that determines which private key can decrypt which SopsSecrets. In the following example, a SopsProvider is shown with a selector for how a private key is matched, and which SopsSecrets these private keys can decrypt. So a provider is basically a matcher: Where is the key which can decrypt which SopsSecrets, which is based on namespaceSelectors and matchLabels. When used in combination with Capsule, it is very likely to select a tenant as namespaceSelector, [Read More](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#sopsprovider-custom-resource)

Let's create a first provider, which allows to load keys from any namespace without the label `capsule.clastix.io/tenant`. For the secrets within the same namespaces `Sopssecrets` can be decrypted with the loaded keys:

```yaml
kubectl create -f - <<EOF
apiVersion: addons.projectcapsule.dev/v1alpha1
kind: SopsProvider
metadata:
  name: system-provider
spec:
  keys:
  - namespaceSelector:
      matchExpressions:
       - { key: capsule.clastix.io/tenant, operator: NotExists }
  sops:
  - namespaceSelector:
      matchExpressions:
       - { key: capsule.clastix.io/tenant, operator: NotExists }
EOF
```{{exec}}


The second provider, loads keys from any namespace with the label `capsule.clastix.io/tenant` and the value `solar`. For the secrets within the same namespaces `Sopssecrets` can be decrypted with the loaded keys:

```yaml
kubectl create -f - <<EOF
apiVersion: addons.projectcapsule.dev/v1alpha1
kind: SopsProvider
metadata:
  name: solar-provider
spec:
  keys:
  - namespaceSelector:
      matchLabels:
        capsule.clastix.io/tenant: solar
  sops:
  - namespaceSelector:
      matchLabels:
        capsule.clastix.io/tenant: solar
EOF
```{{exec}}

This creates the two providers with no keys yet:

```shell
kubectl get sopsprovider

NAME              STATUS   MESSAGE                    PROVIDERS   AGE
solar-provider    Ready    Reconciliation Succeeded   0           32s
system-provider   Ready    Reconciliation Succeeded   0           5s
```

In the next steps we are going to add keys for different technologies and encrypt `SopsSecrets` with them.

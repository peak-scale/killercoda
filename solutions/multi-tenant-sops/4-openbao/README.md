# Openbao Secrets

[Access the Vault Dashboard here]({{TRAFFIC_HOST1_30080}}). It's not required

Token is `root`

For any interactions with the client you need to set the following environment variables:

```shell
export VAULT_TOKEN="root"
export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)
```{{exec}}

The Vault token needs to be deployed to a namespace where you want to use this keypair. This must match the selector that is set in the SopsProvider `.spec.keys` configuration, so in this case this secret should be deployed in a namespace that is part of the solar tenant. The secret should have the key of sops.vault-token:

## Providing Token

In order for the sops-operator to be able to access and decrypt secrets, which were encrypted using openbao, you must deliver a token (with the correct policies associated). We have already a secret ready:

```shell
cat token.yaml
```

Note that the key for the token must be `sops.vault-token`. Let's apply this secret (it can be applied to any namespace, as both `SopsProviders` should be able to select it):

```shell
kubectl apply -f token.yaml -n kube-system
```

Verify it was considered by both `SopsProviders`:







## Encryption/Decryption

A Transit key-spaces `solar/` and `system` was already initialized with two new keys:

* `solar/keys/key-solar`
* `system/keys/key-system`

Let's inspect the `.sops.yaml` file:

```shell
cat .sops.yaml
```{{exec}}

As you can see, we are referencing the Openbao adress in the `.sops.yaml` and also we are providing which keys we are looking to use. This works with single keys or via `key-groups`:


```yaml

```










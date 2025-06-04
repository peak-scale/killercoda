# Openbao Secrets

[Access the Vault Dashboard here]({{TRAFFIC_HOST1_30080}}). It's not required

Token is `root`

For any interactions with the client you need to set the following environment variables:

```shell
export VAULT_TOKEN="root"
export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)
```{{exec}}

The Vault token needs to be deployed to a namespace where you want to use this keypair. This must match the selector that is set in the SopsProvider `.spec.keys` configuration, so in this case this secret should be deployed in a namespace that is part of the solar tenant. The secret should have the key of sops.vault-token:


A Transit key-space `sops/` was already initialized wiith two new keys:

    * `sops/keys/key-1`
    * `sops/keys/key-2`




bao write -f sops/keys/key-1
bao write -f sops/keys/key-2







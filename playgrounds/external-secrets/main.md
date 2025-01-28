# External Secrets

You will find different approaches how you can decrypt secrets with SOPS. It's best to visit their [documentation](https://getsops.io/) for more information.

A very simplistic example is to use a [Gitlab project as provider](https://external-secrets.io/latest/provider/gitlab-variables/) for the secrets. The secrets are stored in the Gitlab project and the External Secrets Operator reads the secrets and creates Kubernetes Secrets.


# Vault (Openbao)

For any interactions with the client you need to set the following environment variables:

```shell
export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)
```{{exec}}

The client is already installed in the environment, you can use it to interact with the Vault server.

```shell
bao -h
```{{exec}}

Authenticate with root token:

```shell
bao login
```{{exec}}

Value for prompt is `root`{{exec}}

## Tutorial


# External Secrets

You will find different approaches how you can decrypt secrets with SOPS. It's best to visit their [documentation](https://getsops.io/) for more information.

A very simplistic example is to use a [Gitlab project as provider](https://external-secrets.io/latest/provider/gitlab-variables/) for the secrets. The secrets are stored in the Gitlab project and the External Secrets Operator reads the secrets and creates Kubernetes Secrets.

## Gitlab

There's aleady a Gitlab Secret being synced by external secrets operator.

View the SecretStore:

```shell
kubectl get SecretStore -n eso-gitlab -o yaml
```{{exec}}

The `ExternalSecret` is already created and synced with the Vault Secret:

```shell
kubectl get ExternalSecret -n eso-gitlab -o yaml
```{{exec}}


## Vault

There's aleady a Vault Secret being synced by external secrets operator.

View the SecretStore:

```shell
kubectl get SecretStore -n eso-vault -o yaml
```{{exec}}

The `ExternalSecret` is already created and synced with the Vault Secret:

```shell
kubectl get ExternalSecret -n eso-vault -o yaml
```{{exec}}

# Vault (Openbao)

[Access the Vault Dashboard here]({{TRAFFIC_HOST1_30080}}).

Token is `root`

For any interactions with the client you need to set the following environment variables:

```shell
export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)
```{{exec}}

The client is already installed in the environment, you can use it to interact with the Vault server.

```shell
vault -h
```{{exec}}

Authenticate with root token:

```shell
vault login
```{{exec}}

Value for prompt is `root`{{exec}}
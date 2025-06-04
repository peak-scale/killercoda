# Openbao

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
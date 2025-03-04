# Sealed Secrets

Let's see how you encrypt a first secret and deploy it to the cluster.

## Seal a Secret

Create a json/yaml-encoded Secret somehow:

```shell
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o json > mysecret.json
```{{exec}}

You can inspect the secret, this is not secure to be published anywhere since it's only base64 encoded.

```shell
cat mysecret.json
```{{exec}}

This is the important bit:

```shell
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets -f mysecret.json -w mysealedsecret.json
```{{exec}}

You can inspect the sealed secret file `mysealedsecret.json`, this is safe to be published anywhere.

```shell
cat mysealedsecret.json
```{{exec}}

At this point `mysealedsecret.json` is safe to upload to Github, post on Twitter, etc. :D

```shell
kubectl create -f mysealedsecret.json
```{{exec}}

Profit! 

```shell
kubectl get secret mysecret
```{{exec}}

For every command you require `kubeseal`, you need to pass the following args:

```shell
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets
```{{copy}}

You can also use the web [interface]({{TRAFFIC_HOST1_30080}})

There are further Usage examples and more information on the [Sealed Secrets GitHub page](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#usage)


# Controller

Note that this controller has a static sealing key-pair. So any secrets encrypted will use the same base key-pair, that's mainly for demonstration purposes. [Read More]()

# Tools

Additional tools, that can be used in combination with Sealed-Secrets.

## Sealed-Secrets-Web

[Sealed-Secrets-Web](https://github.com/bakito/sealed-secrets-web) is a web interface to manage your Sealed Secrets. You can access it [here]({{TRAFFIC_HOST1_30080}}).
# OpenPGP Secrets

**It's recommended to use AGE (Next Step) over OpenPGP**

We have already imported two private keys were to the local keyring. We now need to bring these private keys also to the Kubernetes API. You can view the keys under:

```
ls keys
```{{exec}}

## Providing Keys

> [Read the documentation](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#option-2-gnu-openpgp-key-pair)

We have provided already to private-keys which can be used to decrypt secrets. The Manifests are already prepared:

```shell
cat keys/key-1/key.yaml
cat keys/key-2/key.yaml
```{{exec}}

**Note**: The secrets have the label `sops.addons.projectcapsule.dev: "true"` to be considered by the controller. There might be more labels required, depending on the `SopsProvider` configuration.

Let's apply the keys to different namespaces:

```shell
kubectl apply -f keys/key-1/key.yaml -n kube-system

kubectl apply -f keys/key-2/key.yaml -n solar-prod
```{{exec}}

Each `SopsProviders` should now have one key associated:

```shell

```







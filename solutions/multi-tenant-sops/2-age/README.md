# AGE Secrets

>  **It's recommended to use AGE over OpenPGP. However OpenPGP is also supported.**


## Providing Keys

> [Documentation](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#option-1-age-key-pair)

We have created already two age-keys, you can inspect them:

```yaml
cat keys/key-1.agekey
cat keys/key-2.agekey
```

These keys can now be loaded into Kubernetes secrets, to be used with the sops-controller. Note that the key for the keys must have `.agekey` as suffix. We have already created the secrets, containing the keys. Let's apply them to different namespaces:

```shell
kubectl apply -f keys/key-1.yaml -n kube-system
kubectl apply -f keys/key-2.yaml -n solar-prod
```{{exec}}

**Note**: The secrets are labeled with  `sops.addons.projectcapsule.dev: "true"`, this label must be present for the secrets to be considered for the sops-ocntroller.



## Encrypt Secrets

To encrypt secrets using sops we need need the public key, which is easiest stored in the `.sops.yaml` file. We have already done that for you, look at:

```shell
cat .sops.yaml
```

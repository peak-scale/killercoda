# AGE Secrets

>  **It's recommended to use AGE over OpenPGP. [However OpenPGP is also supported](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#option-2-gnu-openpgp-key-pair).**

## Providing Keys

> [Documentation](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#option-1-age-key-pair)

We have created already two age-keys, you can inspect them:

```yaml
cat keys/key-1.agekey
cat keys/key-2.agekey
```{{exec}}

These keys can now be loaded into Kubernetes secrets, to be used with the sops-controller. Note that the key for the keys must have `.agekey` as suffix. We have already created the secrets, containing the keys. Let's apply them to different namespaces:

```shell
kubectl apply -f keys/key-1.yaml -n kube-system
kubectl apply -f keys/key-2.yaml -n solar-prod
```{{exec}}

**Note**: The secrets are labeled with  `sops.addons.projectcapsule.dev: "true"`, this label must be present for the secrets to be considered for the sops-ocntroller.

We should now be able to verify, that the `SopsProviders` each picked up one of the age-keys:

```shell
kubectl get sopsprovider -A
```{{exec}}

Should look like this:

```shell
NAME              STATUS   MESSAGE                    PROVIDERS   AGE
solar-provider    Ready    Reconciliation Succeeded   1           94s
system-provider   Ready    Reconciliation Succeeded   1           94s
```

You can also insepct each provider and the status tells you, which secrets were loaded:

```shell
 kubectl get sopsprovider solar-provider -o yaml
 ```{{exec}}

Looks something like this:

```yaml
...
status:
  condition:
    lastTransitionTime: "2025-06-05T13:03:28Z"
    message: Reconciliation Succeeded
    observedGeneration: 1
    reason: Loaded
    status: "True"
    type: Ready
  providers:
  - condition:
      lastTransitionTime: "2025-06-05T13:03:28Z"
      message: Reconciliation Succeeded
      reason: Loaded
      status: "True"
      type: Ready
    name: age-key-2
    namespace: solar-prod
    uid: 72a25bd4-8609-471b-a4ff-f423b62a4224
  size: 1
```

You have successfully added AGE keys to the clusters and providers are picking them up.

## Encrypt Secrets

To encrypt secrets using sops we need need the public key, which is easiest stored in the `.sops.yaml` file. We have already done that for you, look at:

```shell
cat .sops.yaml
```{{exec}}

You can now simply encrypt using sops, the commands for all the available files:

```shell
sops -e secret-key-1.yaml > secret-key-1.enc.yaml
```{{exec}}

```shell
sops -e secret-key-2.yaml > secret-key-2.enc.yaml
```{{exec}}

```shell
sops -e secret-multi.yaml > secret-multi.enc.yaml
```{{exec}}

All the files which were just encrypted (`*.enc.yaml`) can be pushed to git and are essentially safe to publish. The origin files, should not be pushed anywhere.

## Decrypt Secrets

Now decryption happens on the cluster, so therefor we can directly apply these sops encrypted to the Kubernetes API:

```shell
kubectl apply -f secret-key-2.enc.yaml -n solar-test
```{{exec}}

Since we allowed to decrypt secrets in namespaces with the label `capsule.clastix.io/tenant: solar`, we can create `SopsSecrets` in the namespace `solar-test`. We can see, that the secret was successfully depcryted:

```shell
kubectl get sopssecret  -n solar-test
```{{exec}}

We can verify, which secrets are replicated:

```shell
kubectl get sopssecret secret-key-2  -n solar-test -o jsonpath='{.status.secrets}' | jq
```{{exec}}

Or just verify that native Kubernetes secrets are available:

```shell
kubectl get secrets -n solar-test
```{{exec}}

If we now try to try to decrypt the first secret in the `solar-test` namespace, we will get an error:

```shell
kubectl apply -f secret-key-1.enc.yaml -n solar-test
```{{exec}}

We can see, that this `SopsSecret` could not be decrypted:

```shell
kubectl get sopssecret secret-key-1  -n solar-test
```{{exec}}

It's current status:

```shell
NAME           SECRETS   STATUS     MESSAGE                        AGE
secret-key-1   1         NotReady   Secret reconciliation failed   2m30s
```

The reason for that is, that the age-key 1 is not exposed to these namespaces, therefor the secret can not be decrypted. If we apply the secret to a different namespace:

```shell
kubectl apply -f secret-key-1.enc.yaml -n kube-system
```{{exec}}

We can see, that the `SopsSecret` was successfully decrypted:

```shell
kubectl get sopssecret secret-key-1  -n kube-system
NAME           SECRETS   STATUS   MESSAGE             AGE
secret-key-1   1         Ready    Secrets Decrypted   8s
```

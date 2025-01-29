# Decrypt Secrets

You will find different approaches how you can decrypt secrets with SOPS. It's best to visit their [documentation](https://getsops.io/) for more information.

Let's see how you encrypt a first secret and deploy it to the cluster.

## SOSP Decryption (Flux Example)

There's already a Flux Kustomization using SOPS to decrypt a secret, you can look ath the kustomization:

```shell
kubectl get kustomization -o yaml -n flux-sops
```{{exec}}

We need to make changes to the secrets, therefor we are changing directories (this directory is synced by flux):

```shell
cd .assets/example
```

You can see `basic-auth.yaml`, which is encrypted:

```shell
cat basic-auth.yaml
```{{exec}}

But not encrypted applied in the actual namespace:

```shell
kubectl get secret basic-auth -o yaml -n flux-sops
```{{exec}}

Now let's create a new Secret:

```shell
cat > secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: secret-basic-auth
type: kubernetes.io/basic-auth
stringData:
  username: admin
  password: t0p-Secret
EOF
```{{copy}}

Now we want to encrypt this file using sops:

```shell
sops -e -i secret.yaml
```{{exec}}

Looking at the file, it's now encrypted:





Can you decrypt again?

```shell
sops -d -i secret.yaml
```

## Decrypt a secret (SOPS Operator/Argo)

Lets create a secret file locally:

```
cat > secrets.yaml <<EOF
apiVersion: isindir.github.com/v1alpha3
kind: SopsSecret
metadata:
  name: example-sopssecret
spec:
  # suspend reconciliation of the sops secret object
  suspend: false
  secretTemplates:
    - name: my-secret-name-1
      labels:
        label1: value1
      annotations:
        key1: value1
      stringData:
        data-name0: data-value0
      data:
        data-name1: ZGF0YS12YWx1ZTE=
    - name: some-token
      stringData:
        token: Wb4ziZdELkdUf6m6KtNd7iRjjQRvSeJno5meH4NAGHFmpqJyEsekZ2WjX232s4Gj
    - name: docker-login
      type: 'kubernetes.io/dockerconfigjson'
      stringData:
        .dockerconfigjson: '{"auths":{"index.docker.io":{"username":"imyuser","password":"mypass","email":"myuser@abc.com","auth":"aW15dXNlcjpteXBhc3M="}}}'
EOF
```{{copy}}


```shell
sops --encrypt \
  --pgp 'A891D1199063B2B7CAA2DF40941386AD617DB8AC' \
  --encrypted-suffix='Templates' secrets.yaml \
  > secrets.enc.yaml
```{{exec}}

Import the private key:

```shell
kubectl get secret -n sops sops-gpg -o jsonpath='{.data.sops\.asc}' | base64 -d | gpg --import
```{{exec}}






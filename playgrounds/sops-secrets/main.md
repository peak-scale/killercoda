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
```{{exec}}

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
```{{exec}}

Now we want to encrypt this file using sops:

```shell
sops -e -i secret.yaml
```{{exec}}

We will get an error, this is expected:

```shell
Could not generate data key: [failed to encrypt new data key with master key "A891D1199063B2B7CAA2DF40941386AD617DB8AC": could not encrypt data key with PGP key: github.com/ProtonMail/go-crypto/openpgp error: key with fingerprint 'A891D1199063B2B7CAA2DF40941386AD617DB8AC' is not available in keyring; GnuPG binary error: failed to encrypt sops data key with pgp: gpg: keybox '/root/.gnupg/pubring.kbx' created
gpg: A891D1199063B2B7CAA2DF40941386AD617DB8AC: skipped: No public key
gpg: [stdin]: encryption failed: No public key]
```

with sops we have certain configurations, when it comes to handling files. In the current directory, there's a `.sops.yaml` file. Looking at this file reveals, that files with glob `.*.yaml` under the YAML structure `data|stringData` (All Kubernetes secerets) are encrypted using the public key with Fingerprint `A891D1199063B2B7CAA2DF40941386AD617DB8AC`

```shell
cat .sops.yaml 
creation_rules:
  - path_regex: .*.yaml
    encrypted_regex: ^(data|stringData)$
    pgp: A891D1199063B2B7CAA2DF40941386AD617DB8AC
```

It's a best practice to provide the public key in the repository, since it's not critical information. People which get their hands on the public key, can encrypt secrets, but not decrypt them. In this case we have a `.sops.pub.asc` file. Let's import it, since it's a PGP Publickey:

```shell
gpg --import .sops.pub.asc
```{{exec}}

Now that we have the public-key imported, we should be able to encrypt the file:

```shell
sops -e -i secret.yaml
```{{exec}}

Looking at the file, it's now encrypted:

```shell
cat secret.yaml
```{{exec}}

Can you decrypt the file again, to change it's content?

```shell
sops -d -i secret.yaml
```{{exec}}

That now also fails, because you are missing the private-key. The private-key is always required to decrypt information with SOPS. And that's also the trickiest aspect, distiputing private-keys to the correct people and in a safe fashion:

```shell
Failed to get the data key required to decrypt the SOPS file.

Group 0: FAILED
  A891D1199063B2B7CAA2DF40941386AD617DB8AC: FAILED
    - | could not decrypt data key with PGP key:
      | github.com/ProtonMail/go-crypto/openpgp error: could not
      | load secring: open /root/.gnupg/pubring.gpg: no such file or
      | directory; GnuPG binary error: failed to decrypt sops data
      | key with pgp: gpg: encrypted with 4096-bit RSA key, ID
      | F3E671C58C638E83, created 2025-01-28
      |       "cluster0.yourdomain.com (flux secrets)"
      | gpg: decryption failed: No secret key

Recovery failed because no master key was able to decrypt the file. In
order for SOPS to recover the file, at least one key has to be successful,
but none were.
```

In our case we can import the private-key from a Kubernetes secret:

```shell
kubectl get secret -n sops sops-gpg -o jsonpath='{.data.sops\.asc}' | base64 -d | gpg --import
```{{exec}}

Now the decryption should correctly work:

```shell
sops -d -i secret.yaml
```{{exec}}

We are back to plain content:

```shell
cat secret.yaml
```{{exec}}

You may need additional measures to prevent secrets being pushed to Git like [Gitleaks](https://github.com/gitleaks/gitleaks)

## Decrypt a secret (SOPS Operator/Argo)

> This section is under construction

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






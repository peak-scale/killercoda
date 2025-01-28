# Decrypt Secrets

You will find different approaches how you can decrypt secrets with SOPS. It's best to visit their [documentation](https://getsops.io/) for more information.

Let's see how you encrypt a first secret and deploy it to the cluster.

## Decrypt a secret

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

sops --encrypt \
  --pgp 'A891D1199063B2B7CAA2DF40941386AD617DB8AC' \
  --encrypted-suffix='Templates' secrets.yaml \
  > secrets.enc.yaml

A891D1199063B2B7CAA2DF40941386AD617DB8AC


Import the private key:

```shell
kubectl get secret -n sops sops-gpg -o jsonpath='{.data.sops\.asc}' | base64 -d | gpg --import
```{{exec}}






echo "Installing scenario..."
while [ ! -f /tmp/finished ]; do sleep 2; done
echo "Ready to Play!"

VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)

echo "Logging into Bao Server ($VAULT_ADDR) 🦄"
echo "root" | bao login  -

echo "Creating Bao Policy 🦄"
bao policy write developer-vault-policy - << EOF
path "dev-secrets/+/creds" {
   capabilities = ["create", "list", "read", "update"]
}
EOF

echo "New Secrets Path 🦄"
bao secrets enable -path=dev-secrets -version=2 kv

echo "Creating Token 🦄"
TOKEN=$(bao token create -policy=developer-vault-policy -id=eso-token -field=token_accessor)

echo "Got Token $TOKEN 🦄"

echo "Creating ESO SecretStore"
kubectl create ns eso-vault
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: dev-secrets
  namespace: eso-vault
spec:
  provider:
    vault:
      server: "${VAULT_ADDR}"
      path: "secret"
      version: "v2"
      auth:
        # points to a secret that contains a vault token
        # https://www.vaultproject.io/docs/auth/token
        tokenSecretRef:
          name: "vault-token"
          key: "token"
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: eso-vault
stringData:
  token: ${TOKEN}
EOF



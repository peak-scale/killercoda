echo "Installing scenario..."
while [ ! -f /tmp/finished ]; do sleep 2; done
echo "Ready to Play!"

export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)

echo "Logging into Bao Server ($VAULT_ADDR) 🦄"
echo "root" | bao login  -

echo "Enable Database 🦄"
bao secrets enable database
bao auth enable userpass

echo "Creating Bao Policy 🦄"
bao policy write developer-vault-policy - << EOF
path "dev-secrets/+/creds" {
   capabilities = ["create", "list", "read", "update"]
}
EOF

echo "New Secrets Path 🦄"
bao secrets enable -path=dev-secrets -version=2 kv

echo "Creaing User eso-dev-syncer:eso-dev-syncer 🦄"
bao write /auth/userpass/users/eso-dev-syncer \
    password='eso-dev-syncer' \
    policies=developer-vault-policy

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
      server: "http://openbao.openbao.svc:8200"
      path: "secret"
      version: "v2"
      auth:
        userPass:
          # Path where the UserPass authentication backend is mounted
          path: "userpass"
          username: "eso-dev-syncer"
          secretRef:
            name: "vault-token"
            key: "token"
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: eso-vault
stringData:
  token:  eso-dev-syncer
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: dev-secrets
  namespace: eso-vault
spec:
  refreshInterval: "15s"
  secretStoreRef:
    name: dev-secrets
    kind: SecretStore
  target:
    name: dev-secrets
  data: 
  - secretKey: api-key
    remoteRef:
      key: "dev-secrets/creds"
      property: "api-key" 
EOF


bao kv put /dev-secrets/creds api-key=E6BED968-0FE3-411E-9B9B-C45812E4737A



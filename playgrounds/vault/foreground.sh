echo "Installing scenario..."
while [ ! -f /tmp/finished ]; do sleep 2; done
echo "Ready to Play!"

export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)

echo "Logging into Vault Server ($VAULT_ADDR) 🦄"
echo "root" | vault login  -

echo "Enable Database 🦄"
vault secrets enable database
vault auth enable userpass

echo "Creating vault Policy 🦄"
vault policy write developer-vault-policy - << EOF
path "dev-secrets/+/creds" {
   capabilities = ["create", "list", "read", "update"]
}
EOF

echo "New Secrets Path 🦄"
vault secrets enable -path=dev-secrets -version=2 kv

echo "Creaing User eso-dev-syncer:eso-dev-syncer 🦄"
vault write /auth/userpass/users/eso-dev-syncer \
    password='eso-dev-syncer' \
    policies=developer-vault-policy

echo "Adding Data 🦄"
vault kv put /dev-secrets/creds api-key=E6BED968-0FE3-411E-9B9B-C45812E4737A

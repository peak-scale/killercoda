export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)

echo "Logging into Vault Server ($VAULT_ADDR) 🦄"
echo "root" | bao login  -

bao secrets enable -path=sops transit

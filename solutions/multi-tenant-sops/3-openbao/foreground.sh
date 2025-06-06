cd /root/openbao

export VAULT_ADDR=$(sed 's/PORT/30820/g' /etc/killercoda/host)
export BAO_TOKEN="root"

cat <<EOF > "/root/openbao/.sops.yaml"
creation_rules:
    - path_regex: secret-key-1.yaml
      encrypted_regex: ^(data|stringData)$
      hc_vault_transit_uri: "${VAULT_ADDR}/v1/solar/keys/key-solar"

    - path_regex: secret-key-2.yaml
      encrypted_regex: ^(data|stringData)$
      hc_vault_transit_uri: "${VAULT_ADDR}/v1/system/keys/key-system"

    - path_regex: secret-multi.yaml
      encrypted_regex: ^(data|stringData)$
      shamir_threshold: 1
      key_groups:
        - hc_vault:
            - "${VAULT_ADDR}/v1/solar/keys/key-solar"
            - "${VAULT_ADDR}/v1/system/keys/key-system"

    - path_regex: secret-quorum.yaml
      encrypted_regex: ^(data|stringData)$
      shamir_threshold: 2
      key_groups:
        - hc_vault:
            - "${VAULT_ADDR}/v1/solar/keys/key-solar"
            - "${VAULT_ADDR}/v1/system/keys/key-system"
EOF


echo "Logging into Vault Server ($VAULT_ADDR) 🦄"
echo "root" | bao login  -

bao secrets enable -path=solar transit
bao secrets enable -path=system transit

bao write -f solar/keys/key-solar
bao write -f system/keys/key-system

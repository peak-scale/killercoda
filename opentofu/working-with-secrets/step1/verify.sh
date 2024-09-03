#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step1"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/export.sh"
export TF_VAR_postgres_password="mydatabasepassword"
EOF

if [ $(kubectl get secret postgres-postgresql -o jsonpath='{.data.postgres-password}'| base64 -d) = "mydatabasepassword" ]; then
  exit 1
fi
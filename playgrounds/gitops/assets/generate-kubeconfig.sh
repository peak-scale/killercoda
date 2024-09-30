#!/bin/bash

# Usage: ./create_kubeconfig.sh <service_account_name> <namespace> <output_file>

SERVICE_ACCOUNT=$1
NAMESPACE=$2
OUTPUT_FILE=$3

if [[ -z "$SERVICE_ACCOUNT" || -z "$NAMESPACE" || -z "$OUTPUT_FILE" ]]; then
  echo "Usage: $0 <service_account_name> <namespace> <output_file>"
  exit 1
fi

# Extract the Kubernetes API server URL and CA certificate from environment variables
SERVER_URL=$(sed 's/PORT/6443/g' /etc/killercoda/host)
CLUSTER_NAME="killercoda"

# Get the service account secret name
SECRET_NAME=$(kubectl -n $NAMESPACE get sa $SERVICE_ACCOUNT -o jsonpath='{.secrets[0].name}')

# Get the service account token
TOKEN=$(kubectl -n $NAMESPACE get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode)

# Create the kubeconfig file
cat <<EOF > $OUTPUT_FILE
apiVersion: v1
kind: Config
clusters:
- name: $CLUSTER_NAME
  cluster:
    server: $SERVER_URL
    insecure-skip-tls-verify: true
contexts:
- name: $SERVICE_ACCOUNT@$CLUSTER_NAME
  context:
    cluster: $CLUSTER_NAME
    namespace: $NAMESPACE
    user: $SERVICE_ACCOUNT
current-context: $SERVICE_ACCOUNT@$CLUSTER_NAME
users:
- name: $SERVICE_ACCOUNT
  user:
    token: $TOKEN
EOF

echo "Kubeconfig written to $OUTPUT_FILE"

#!/bin/bash
if ! kubectl get namespace dev-environment &> /dev/null; then
  exit 1
fi

# Check if the serviceaccount 'dev-sa' exists in the namespace 'dev-environment'
if ! kubectl get serviceaccount dev-sa -n dev-environment &> /dev/null; then
  echo "ServiceAccount 'dev-sa' does not exist in namespace 'dev-environment'."
  exit 1
fi

# Check if the pod 'nginx' exists in the namespace 'dev-environment'
if ! kubectl get pod nginx -n dev-environment &> /dev/null; then
  exit 1
fi

# Verify the details of the pod 'nginx'
nginx_pod=$(kubectl get pod nginx -n dev-environment -o json)

# Check if the pod has the correct service account
pod_sa=$(echo "$nginx_pod" | jq -r '.spec.serviceAccountName')
if [[ "$pod_sa" != "dev-sa" ]]; then
  exit 1
fi

# Check if the pod has the correct container name, image, and exposed port
container_name=$(echo "$nginx_pod" | jq -r '.spec.containers[0].name')
container_image=$(echo "$nginx_pod" | jq -r '.spec.containers[0].image')
container_port=$(echo "$nginx_pod" | jq -r '.spec.containers[0].ports[0].containerPort')

if [[ "$container_name" != "nginx" ]]; then
  exit 1
fi

if [[ "$container_image" != "nginx:latest" ]]; then
  exit 1
fi

if [[ "$container_port" -ne 80 ]]; then
  exit 1
fi
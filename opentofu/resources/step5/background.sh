#!/bin/bash
kubectl create namespace dev-environment || true
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: "busybox"
  namespace: "dev-environment"
spec:
  containers:
    - name: "busybox"
      image: "busybox:latest"
      ports:
        - containerPort: 80
      command: ["sleep", "infinity"]
EOF

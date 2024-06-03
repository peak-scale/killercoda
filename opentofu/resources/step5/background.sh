
#!/bin/bash
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Pod
metadata:
  name: "busybox"
  namespace: "prod-environment"
spec:
  serviceAccountName: "prod-sa"
  containers:
    - name: "nginx"
      image: "nginx:latest"
      ports:
        - containerPort: 80
EOF
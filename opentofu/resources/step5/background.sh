
#!/bin/bash
kubectl create namespace prod-environment || true
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: "busybox"
  namespace: "prod-environment"
spec:
  containers:
    - name: "busybox"
      image: "busybox:latest"
      ports:
        - containerPort: 80
      command: ["sleep", "infinity"]
EOF
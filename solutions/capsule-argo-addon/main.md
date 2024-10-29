# Tenants

To see all the tenants you can execute the following command:

```shell
kubectl get tnt -o yaml
```{{exec}}

# Argo

You can access [ArgoCD Dashboard]({{TRAFFIC_HOST1_30080}}) to start playing around with argocd. The following Users are available:

- name: `admin`{{copy}}
  password: `admin`{{copy}}

- name: `alice`{{copy}}
  password: `admin`{{copy}}

- name: `bob`{{copy}}
  password: `admin`{{copy}}
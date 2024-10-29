# Tenants

To see all the tenants you can execute the following command:

```shell
kubectl get tnt -o yaml
```{{exec}}

# Argo

You can access [ArgoCD Dashboard]({{TRAFFIC_HOST1_30080}}) to start playing around with argocd. The following Users are available:

The credentials for the login are:

- Username: `admin`
- Password: `admin`

![ArgoCD Login](./media/argocd-landing.png)

The [argocd cli](https://argo-cd.readthedocs.io/en/stable/getting_started/) is available:

```shell
argocd -h
```{{exec}}


# FluxCD

The [flux cli](https://fluxcd.io/flux/cmd/) is available:

```shell
flux -h
```{{exec}}

## Tofu-Controller

# Cluster Access (Kubeconfig)

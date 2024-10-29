![Addon Icon](https://github.com/peak-scale/capsule-argo-addon/raw/main/docs/images/capsule-argo.png)

# The Addon

This addon is designed for kubernetes administrators, to automatically translate their existing Capsule Tenants into Argo Appprojects. This addon adds new capabilities to the Capsule project, by allowing the administrator to create a new tenant in Capsule, and automatically create a new Argo Appproject for that tenant. This addon is designed to be used in conjunction with the Capsule project, and is not intended to be used as a standalone project.

[See the Source]()

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

# Traffic Ports

You can access ports from the nodes in this scenario. On the top right you can see a small burger-menu. Click on it and select `Traffic / Ports`:

![Traffic Ports 1](./media/traffic-port-accessor-1.png)

On this overview we can select which ports we want to forward to which node. For this scenario we are mainly going to use **Host 2**:

![Traffic Ports 2](./media/traffic-port-accessor-2.png)

You will be instructed with specific ports for the following technologies.

# ArgoCD

To Access ArgoCD you must use the [Traffic Port](#traffic-ports) `30080` on **Host 2**:

![ArgoCD](./media/argocd-port.png)

Once you have the port, you can access the ArgoCD Dashboard. The credentials are

- Username: `admin`
- Password: `admin`

The [argocd cli](https://argo-cd.readthedocs.io/en/stable/getting_started/) is available:

```shell
argocd -h
```{{exec}}


# FluxCD

The [flux cli](https://fluxcd.io/flux/cmd/) is available:

```shell
flux -h
```{{exec}}


# Cluster Access (Kubeconfig)


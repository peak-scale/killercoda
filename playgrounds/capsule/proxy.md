
# Capsule Proxy

The [Capsule-Proxy](https://github.com/projectcapsule/capsule-proxy) intercepts `LIST` operations to the cluster and adds matching labels, so that the user making the request only sees the resources from their tenants. This way the users only see the resources they really are allowed to see with `LIST` operations. Most tools require LIST operations to properly display content or in general your users want to know, what their current deployed inventory looks like.

This setup works best, if you are using [OIDC or similar to authenticate your users](https://projectcapsule.dev/docs/operating/authentication/). In this ephermal environment we will be using [Certificate-Based authentication](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/)

To work with the proxy, it's easiest to run a port-forward. You can open a new tab to get it up and it must be open, while executing the other commands:

```shell
kubectl port-forward svc/capsule-proxy 9001:9001 -n capsule-system
```{{exec}}

## Personas

Now we can impersonate the view for `alice`, with using this kubeconfig:

```shell
kubectl --kubeconfig /root/.kubconfigs/alice.kubeconfig get ns
```{{exec}}

And for `bob`:

```shell
kubectl --kubeconfig /root/.kubconfigs/bob.kubeconfig get ns
```{{exec}}

## Listing

Now as alice you are able to LIST all of the `namespaced` APIs:

```shell
kubectl --kubeconfig /root/.kubconfigs/alice.kubeconfig get pod -A
kubectl --kubeconfig /root/.kubconfigs/alice.kubeconfig get svc -A
```

And certain cluster-scoped APIs:

```shell
kubectl --kubeconfig /root/.kubconfigs/alice.kubeconfig get ns
```{{exec}}

## ProxySettings




## Integrations (UX)

Capsule offers different [integrations](https://projectcapsule.dev/ecosystem/) with tools from the CNCF ecosystem. Essentially any Operators which work with the Kubernets API natively.

### Kubernetes-Dashboard

The Kubernetes Dashboard natively proxies user attributes to the Kubernets API. This allows us to proxy these Requests via the [Capsule-Proxy](https://github.com/projectcapsule/capsule-proxy). This way the users only see the resources they really are allowed to see with `LIST` operations.

[Access the Kubernets Dashboard here]({{TRAFFIC_HOST1_30080}}). You can use the following users:

  * `username`: `alice`
    `password`: `alice`
    `groups`: `projectcapsule.dev`

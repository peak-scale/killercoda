
# Capsule Proxy

The [Capsule-Proxy](https://github.com/projectcapsule/capsule-proxy) intercepts `LIST` operations to the cluster and adds matching labels, so that the user making the request only sees the resources from their tenants. This way the users only see the resources they really are allowed to see with `LIST` operations. Most tools require LIST operations to properly display content or in general your users want to know, what their current deployed inventory looks like.





## Integrations (UX)

Capsule offers different [integrations](https://projectcapsule.dev/ecosystem/) with tools from the CNCF ecosystem. Essentially any Operators which work with the Kubernets API natively.

### Kubernetes-Dashboard

The Kubernetes Dashboard natively proxies user attributes to the Kubernets API. This allows us to proxy these Requests via the [Capsule-Proxy](https://github.com/projectcapsule/capsule-proxy). This way the users only see the resources they really are allowed to see with `LIST` operations.

[Access the Kubernets Dashboard here]({{TRAFFIC_HOST1_30080}}). You can use the following users:

  * `username`: `alice`
    `password`: `alice`
    `groups`: `projectcapsule.dev`

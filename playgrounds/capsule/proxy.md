
# Capsule Proxy




## Integrations (UX)

Capsule offers different [integrations](https://projectcapsule.dev/ecosystem/) with tools from the CNCF ecosystem. Essentially any Operators which work with the Kubernets API natively.

## Kubernetes-Dashboard

The Kubernetes Dashboard natively proxies user attributes to the Kubernets API. This allows us to proxy these Requests via the [Capsule-Proxy](https://github.com/projectcapsule/capsule-proxy). This way the users only see the resources they really are allowed to see with `LIST` operations.

# SOPS Providers

The SopsProvider Custom Resource is essentially a connector that determines which private key can decrypt which SopsSecrets. In the following example, a SopsProvider is shown with a selector for how a private key is matched, and which SopsSecrets these private keys can decrypt. So a provider is basically a matcher: Where is the key which can decrypt which SopsSecrets, which is based on namespaceSelectors and matchLabels. When used in combination with Capsule, it is very likely to select a tenant as namespaceSelector, [Read More](https://github.com/peak-scale/sops-operator/blob/main/docs/usage.md#sopsprovider-custom-resource)


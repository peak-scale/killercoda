# Tenants

To see all the tenants you can execute the following command:

```shell
kubectl get tnt -o yaml
```{{exec}}

# Headlamp

You can access [Headlamp]({{TRAFFIC_HOST1_30080}}) to start playing around with argocd. The following Users are available:

- name: `admin`{{copy}}
  password: `admin`{{copy}}

- name: `alice`{{copy}}
  password: `admin`{{copy}}

- name: `bob`{{copy}}
  password: `admin`{{copy}}

Now we need to understand how these users are translated from tenants to Argo Appprojects. Note this also works with groups, but that's difficult to emulate with local argo users.

To play around with the UI you can login with these users and deploy workloads in the appprojects, where they have the permissions to do so. Sample Projects:

- [https://github.com/stefanprodan/podinfo](https://github.com/stefanprodan/podinfo)

# Tenants

Below we see the three tenants currently deployed. It's also shown which of the above users have which clusterRoles on the tenants

- **solar**
  - alice:
    - admin
  - bob:
    - tenant-viewer

- **oil**
  - alice:
    - admin
  - bob:
    - admin
    - tenant-viewer

- **wind**
  - alice:
    - tenant-viewer
  - bob:
    - admin

To see all the tenants you can execute the following command:

```shell
kubectl get tnt -o yaml
```{{exec}}

You will notice, that the tenants have different [Annotations](https://github.com/peak-scale/capsule-argo-addon/blob/main/docs/annotations.md), influencing the way they are lifecycled and patched by the operator

# Translators

Translators consider a Tenant and create a corresponding Argo Appproject. That's why they are called Translators. Currently One Capsule Tenant can result in maximum 1 Argo Appproject. However once Capsule Tenant can be matched by n-amount of Translators.

## Permissions

Based on these ClusterRoles, we have created the argoTranslators `default-onboarding` and `dev-onboarding`. Let's take a look at the relevant roles that are translated:

**default-onboarding**:

```yaml
...

  roles:
  # This creates the baseline role. All users with the cluster-role "admin" will be able to access all repositories
  - name: "viewer"
    clusterRoles:
      - "tenant-viewer"
    policies:
    - resource: "*"
      action: ["get"]
  - name: "owner"
    # Selects entities which are mapped to the clusterRole "admin
    clusterRoles:
      - "admin"
    # Allows the users to make changes to the appproject (just update verb)
    owner: true
    # Additional policies for the mapped entities. Allows to interact with
    policies:  
    - resource: applications
      action: ["*"]
    - resource: repositories
      action: ["*"]
```

summarized in argo RBAC this translates to:

  - Users with the ClusterRole `tenant-viewer` can `get` any (`*`) resource within the appproject. The users can `get` the `project`
  - Users with the ClusterRole `admin` can do anything (`*`) on `applications` and `repositories`. Because they are `owner`, they can `update` the `project`

You can verify that yourself via the UI.

These translations are applied to tenants, which have the label `app.kubernetes.io/type` with the value `dev` or `prod`


## Settings

The Permissions are the core part of the translation. However you might also want to control Appproject Spec via these Translators. The Translator `default-onboarding` adds these Specs:

```yaml 
  settings:
    structured:
      spec:
        permitOnlyProjectScopedClusters: true
        namespaceResourceWhitelist:
          - group: "*"
            kind: "*"
        clusterResourceWhitelist:
          - group: "*"
            kind: "*"
    template: |
      spec:
        destinations:
          - name: "my-cluster"
            namespace: "my-namespace"
        sourceNamespaces:
        - {{ $.Config.Argo.Namespace | quote }}
        {{- range $_, $value := $.Tenant.Namespaces }}
        - {{ $value | quote }}
        {{- end }}
```

Summarized what this does:

  - In the `structured` we can set literal [Appproject](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/) `spec` and `meta`
  - All resources are whitelisted, since all the tenants get a dedicated `ServiceAccount` to access the cluster. The `ServiceAccount` is already limited to the Capsule Tenant.
  - We can have a `templated` section, if we want to add spec based on conditions or need to use some logic. In this case it's mainly used to allow to deploy applications into the argo installation namespace (Because that's what the GUI does) and to allow applications from any of the tenant's namespaces.

View all the available Translators:

```shell
kubectl get argotranslators -o yaml
```{{exec}}

[Read more on Translators](https://github.com/peak-scale/capsule-argo-addon/blob/main/docs/translators.md)

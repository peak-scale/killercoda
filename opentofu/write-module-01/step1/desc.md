The first thing we now need to do is to think about what we want to achieve and how we can abstract this into a configuration.

# Vision

> This is just a showcase. If you would like to implement such a solution, you should consider using a tool like [Capsule](https://github.com/projectcapsule/capsule).

You have a dedicated cluster and many different developer teams, which would like to work with Kubernetes. You want to share the cluster with all these developers.


# Making a concept

Think about what abstractions we can make:

  * `Tenant`: Is the highest logical abstraction in our scenario. It does not translate to a resource, however should hold relevant information:
  
    * `Metdata`:
      * `Users`: Define Groups/Users having access to this tenant
      * `Quota` ResourceQuota for each namespace
      * `Namespaces`: All the namespaces belonging to a tenant are defined here
  
    * [`Namespace`](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/): Namespace is the logic abstraction we will be using on Kubernetes. It provides the necessary boundaries on the platform.
 
      * [`NetworkPolicy`](https://kubernetes.io/docs/concepts/services-networking/network-policies/): We use NetworkPolicies per namespace to restrict any access to other namespaces.
  
      * [`Role/Rolebinding`](https://kubernetes.io/docs/reference/access-authn-authz/rbac/): We will use the metadata of the tenant to create grant access to the defined users

      * [`ResourceQuota`](https://kubernetes.io/docs/concepts/policy/resource-quotas/): we will the metadata of the tenant to create resourcequotas for each namespace.

We have one other requirement:

  * The tenants should be easily manageable, your consumers would prefer YAML files where they can request 


## Thinking in modules

We should think about where we can make modules and reuse code. 

  * `Tenant`: We can create a module for the tenant, which will create all the necessary resources for a tenant. This module should be reusable and should be able to be used in different clusters.

  * `Namespace`: We can create a module for the namespace, which will create all the necessary resources for a namespace. This module should be reusable and should be able to be used in different clusters. Within this module we will also create all relevant namespaced resources for each namespace. The namespace module should be used in the tenant module.

## User-facing API/Data

I always like to start with the data structure, which the users I am building the solution for are consuming. You probably can't make the perfect abstraction from the start. Therefor keep in mind that it's always good to iterate on the abstraction. 

Based on the above concept we have made above I would envision a following yaml structure:

**tenant.yaml**
```yaml
# For the permissions we need to know Who we are granting access to and what kind of access of property we are using (Username/Groups)
permissions:
  - name: "<groupname/username>"
    kind: "Group/User"

# The Quota is a 1:1 abstraction of the resourceQuota object from Kubernetes
quota:

# Declares the namespaces which are assigned to this tenant
namespaces:
  - namespace-1
  - namespace-2
```

## Verify Provider Capabilities

Before getting your hands dirty, let's look if there's providers which can achieve what we need. In our case we mainly need to take a look at the [Kubernetes Provider]


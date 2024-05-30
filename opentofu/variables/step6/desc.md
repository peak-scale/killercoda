We have seen module outputs in the previous step. When used in a root module, the outputs are available to the user (Console). In this step, we will see how to use these outputs in another module.

There is a new module in `scenario/modules/ingress` that will be used to create an Ingress resource. In this scenario we are going to combine everything we have learned.

## Task 1: Review `module.tf`

There's a new file located in your working directory called `module.tf`. Review the content of the file. With this module we are going to create an Ingress resource. 

The module can be found under `scenario/modules/ingress`.

However for us as consumers, it's relevant to configure 

# Task 2: Deliver Module Variables

To correctly get the resource from the module we need to deliver the required variables. The following Values must be set:

* `namespace_name` - The namespace where the Ingress resource should be created.



# Task 2


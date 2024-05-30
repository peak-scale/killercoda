> [Documentation](https://opentofu.org/docs/language/values/variables/)

Input Variables allow to parameterize the configuration/module and make it reusable. You can think of input variables as parameters to a function. They are defined in the configuration file and can be used to pass values to the resources.

**Note**: Input variables are always declared in a separate file called `variables.tf`. The file is located in the same directory as the configuration file.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Create input variables

> [Documentation](https://opentofu.org/docs/language/values/variables/#declaring-an-input-variable)

Create a new file called `variables.tf` in your working directory. Define the following input variable:

  * `environment`:
    * `type`: string
    * `description`: The environment name

Once done, you can verify with running a plan:

```shell
tofu plan
```{{execute}}

You should be prompted to enter the value for the variable `environment`. Enter `prod` and verify the plan:

```shell
var.environment
  The environment name

  Enter a value: prod
```

## Task 2: Use input variables

> [Documentation](https://opentofu.org/docs/language/values/variables/#using-input-variable-values)

Now that you have the input variable defined, you can use it in the configuration. Replace the hardcoded values with the input variable in the `kubernetes.tf` file. Every occurence of `prod` should be replaced with the input variable. To access the input variable, you can use the following syntax:

* `${var.environment}`

If changed, you can verify the plan again:

> You might have updates regarding pod annotations, which are not relevant.

Nothing has changed, meaning the configuration is still valid and we can rollout our resources for different environments.


```shell
tofu plan
```{{execute}}

## Task 3: Validate Input

> [Documentation](https://opentofu.org/docs/language/values/variables/#custom-validation-rules)

We want to validate the input for our variable `environment`. The environment should only be `prod`, `test` or `dev`. If the input is different, the validation should fail. Add the following condition:

```hcl
validation {
  condition = var.environment == "prod" || var.environment == "test" || var.environment == "dev"
  error_message = "The environment must be either prod, test or dev"
}
```

If you try to run a plan now with a different value than `prod`, `test` or `dev`, the validation should fail.

```shell
tofu plan
```{{execute}}

## Task 4: Set Input Variables

> [Documentation](https://opentofu.org/docs/language/values/variables/#assigning-values-to-root-module-variables)

While it might be a useful workflow to define input variables via an interactive prompt, that option might become unfeasible when the number of variables increases or in automated environments. Let's explore the different ways to declare input variables.

Create a file `terraform.tfvars`, the content of the file should be:

```shell
environment = "test"
```

if you run a plan now, you should see that the variable is set to `test` and all the resources are created in the `test` environment and all the prod resources are replaced.

```shell
tofu plan
```{{execute}}

What happens if you apply the plan?

```shell
tofu apply
```{{execute}}

All resources for the prod environment are removed and the resources for the test environment are created.

## Task 5: Variable Precedence

> [Documentation](https://opentofu.org/docs/language/values/variables/#variable-definition-precedence)

We would like to overwrite the defined variable `environment` with an environment variable. For this we export the environment variable `TF_VAR_environment` with the value `dev`.

```shell
export TF_VAR_environment=dev
```{{execute}}

if you run a plan now, you should see that the variable is set to `dev`:

```shell
tofu plan
```{{execute}}

## Task 6: Declare a default value

In the `variables.tf` file, edit the input variable environment to have a default value of `prod`. Add it as last argument for the variable configuration.

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step3/`.
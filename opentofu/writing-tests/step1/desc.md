
> [Documentation](https://developer.hashicorp.com/terraform/language/tests)

The [`tofu test`](https://opentofu.org/docs/cli/commands/test/) command lets you test your OpenTofu configuration by creating real infrastructure and checking that the required conditions (assertions) are met. Once the test is complete, OpenTofu destroys the resources it created.

By default test files are executed in the root of the module or the test files are expected to be in the `tests` directory.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Review `main.tf`

There's a file located in your `~/scenario` called `main.tf`. Review the content of the file. 

```shell
cat main.tf
```{{execute}}

## Task 2: Implement A Test

Create a new file called `main.tftest.hcl` in the `~/scenario` directory. The test should verify that the `kubernetes.tf` file is syntactically correct.

```shell


# Verify

> If the verification was not successful and you are unsure what the problem is, review the `~/.solutions/step1/kubernetes.tf` file.



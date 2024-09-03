We have a Postgres Helm-Chart we would like to install. We need to pass the password and the username to the Helm-Chart. We don't want to store the password in plain text in our configuration. We will look at different solutions to pass these values.

The simplest solution is to pass it as environment variable to the module. This is not the most secure solution, but it is a good start. Use this approach in Gitlab-CI environments where you can pass the values as environment variables and where the secret variables static.

# Tasks

## Task 1: Export environment variables

Export environment variables which pass the following inputs:

* `postgres_password`: `mydatabasepassword`

## Task 2: Apply

Running an apply will install a Postgres Helm-Chart with the environment variables. 

```shell
tofu apply -f
```{{exec}}

## Task 3: Verify Secret

You can check if your secret was used by checking the value of the secret in the Kubernetes cluster.

```shell
kubectl get secret postgres-postgresql -o jsonpath='{.data.postgres-password}'| base64 -d
```{{exec}}

# Verify

> If the verification was not successful and you are unsure what the problem is, review the files in `~/.solutions/step1/`. You can always copy the solution files to the current working directory by running `cp ~/.solutions/step1/* ~/scenario/`{{copy}}.

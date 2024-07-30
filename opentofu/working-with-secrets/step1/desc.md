We have a Postgres Helm-Chart we would like to install. We need to pass the password and the username to the Helm-Chart. We don't want to store the password in plain text in our configuration. We will look at different solutions to pass these values.

The simplest solution is to pass it as environment variable to the module. This is not the most secure solution, but it is a good start. Use this approach in Gitlab-CI environments where you can pass the values as environment variables and where the secret variables static.

## Task 1: Export environment variables

Export environment variables which pass the following inputs:

  * `postgres_user`: `mydatabaseuser`
  * `postgres_password`: `mydatabasepassword`

Create a new file called `variables.tf` in your working directory. Define the following input variable:




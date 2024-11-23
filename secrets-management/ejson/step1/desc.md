# Introduction

For this scenarios we are using EJSON. With EJSON, Secrets are collected in a JSON file, in which all the string values are encrypted. Public keys are embedded in the file, and the decrypter looks up the corresponding private key from its local filesystem.

* [https://github.com/Shopify/ejson](https://github.com/Shopify/ejson)

# Tasks

## Task 1: Generate a new keypair

With the following command you can generate a new keypair:

```shell
ejson keygen
```{{exec}}

You will have a different output but it should look something like this:

```shell
Public Key:
ab5e9c778df7005ef7693d014bdefb84304225a03e724cf6bf55425b4b2eef7b
Private Key:
c0c0fe9b0234d9876467660501237cea2ae4d1a152815ef96ab39fbebfe81285
```

Here's the explanation for the usage of these keys:

* **Public Key**: This key is used to encrypt the secrets and can be published to a repository or similar.
* **Private Key**: This key is used to decrypt the secrets and should be kept secret. Only Systems or people that need to decrypt the secrets should have access to this key.

Store the private key into a dedicated file called `ejson_privatekey`, based on the example the content of the file should look like this:

```shell
c0c0fe9b0234d9876467660501237cea2ae4d1a152815ef96ab39fbebfe81285
````

## Task 2: Create a new EJSON file

Now create a new EJSON file called `secrets.ejson` with the following content:

```json
{
  "_public_key": "ab5e9c778df7005ef7693d014bdefb84304225a03e724cf6bf55425b4b2eef7b",
  "db_password": "secret_password",
  "api_key": "secret_api_key"
}
```

You must provide your value from the `Public Key` output in the `_public_key` field.

## Task 3: Encrypt the file

Now you can run this command to encrypt the file:

```shell
ejson encrypt secrets.ejson
```{{exec}}

Check the content of the file by running:

```shell
cat secrets.ejson
```{{exec}}

As you can see, the content has been encrypted and the values are not readable anymore. This file can now be safely stored in a repository or similar.

## Task 4: Decrypt the file

To decrypt the file, we need to have the private key available. You can decrypt the file by running the following command:

```shell
cat ejson_privatekey| ejson decrypt secrets.ejson --key-from-stdin
```{{exec}}

This does not decrypt the file in-place but prints the decrypted content to the console. You can redirect the output to a file if you want to save the decrypted content.

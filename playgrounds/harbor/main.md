# Harbor

[Access the portal here]({{TRAFFIC_HOST1_30080}}). Use the following admin credentials:

- Username: `admin`
- Password: `Harbor12345`

Now explore Harbor, a good starting point are possible [administration settings](https://goharbor.io/docs/1.10/administration/).

You can login as `alice`, where you have `projectowner` to a project called `solar`, to see the view for project users:

- Username: `alice`
- Password: `Alice$01`

You can login as `bob`, where you have `guest` to a project called `solar` and `master` to a project called `wind` to see the view for project users:

- Username: `bob`
- Password: `Bobby$01`

## Instance

The Instance has the following URL:

  * {{TRAFFIC_HOST1_30080}}{{copy}}

## User Interactions

We first need to export the url for the harbor into an environment variable (this is just for this ephermal environment required):

```shell
export REGISTRY=$(sed -e 's/^https:\/\///' -e 's/PORT/30080/g' /etc/killercoda/host)
```{{exec}}


Here's how you can interact with the registries, if you would like to pull something from the proxied registiries, you just need to know from which registry, no authentication is necessary since they are public:

```shell
docker pull "${REGISTRY}/dockerhub/busybox"
```{{exec}}

### As Bob

If you want to interact with the `wind` project, you must authroize yourself, since the project is private. The credentials are the same as in the logins above (if you are using external identities via OIDC or similar you create tokens).

Login with the docker client:

```shell
echo -n "Bobby\$01" | docker login "${REGISTRY}/wind" -u bob --password-stdin
```{{exec}}

Let's Tag the busybox image, so we can upload it to the wind project (execute the above pull command previously):

```shell
docker tag  "${REGISTRY}/dockerhub/busybox" "${REGISTRY}/wind/busybox"
```{{exec}}

Push to the wind project

```shell
docker push "${REGISTRY}/wind/busybox"
```{{exec}}

You can now verify that the image was scanned and an SBOM was generated via the Dashboard.

### As Alice

Login as `alice`:

```shell
echo -n "Alice\$01" | docker login "${REGISTRY}/solar" -u alice --password-stdin
echo -n "Alice\$01" | docker login "${REGISTRY}/wind" -u alice --password-stdin
```{{exec}}


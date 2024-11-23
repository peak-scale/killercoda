# Analysis

Different Tools you can use to analyze your container images.

## Dive

> [Github](https://github.com/wagoodman/dive)

The images you are trying to analyze must be present in the local registry. Here an example with the `nginx` image:

```shell
dive nginx:latest
```{{exec}}

## Skopeo

> [Github](https://github.com/containers/skopeo)

`Skopeo` is a command-line utility that performs various operations on container images and image repositories. It allows you to copy, inspect, and sign container images without requiring a local Docker daemon.

```shell
skopeo inspect docker://docker.io/library/nginx:latest
```{{exec}}

## Scanning

> [Github](https://github.com/aquasecurity/trivy)

You can use `trivy` to scan your container images for vulnerabilities. Trivy is a simple and comprehensive vulnerability scanner for containers and other artifacts. A software vulnerability is a glitch, flaw, or weakness present in the software or in an Operating System that could be exploited by an attacker to perform unauthorized actions within the system.

```shell
trivy image nginx:latest
```{{exec}}

# Runtimes

Working with Runtimes in containers. The following runtimes are available in this playground:

## Gvisor

> [Docs](https://gvisor.dev/docs/)

By using `gVisor`, the container runs with an additional layer of security by intercepting and emulating system calls between the container and the host.

```shell 
docker run --runtime=runsc hello-world
```{{exec}}

## CRUN

> [Github](https://github.com/containers/crun)

`crun` is a lightweight and fast container runtime written in C. It is designed to provide a low-overhead alternative to runc, the default runtime for Docker and other container management tools. crun is particularly useful for environments where performance and resource efficiency are critical.

```shell
# Run a container using crun
docker run --runtime=crun alpine echo "Hello from crun"
```{{exec}}
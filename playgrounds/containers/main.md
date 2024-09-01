# Runtimes

## Gvisor

> [Docs](https://gvisor.dev/docs/)

## CRUN

> [Github](https://github.com/containers/crun)

# Analysis

Different Tools you can use to analyze your container images.

## Scout

> [Docs](https://docs.docker.com/scout/explore/analysis/)


```shell
docker scout quickview traefik:latest
```{{exec}}

# Layer Analysis

# Scanning

> [Github](https://github.com/aquasecurity/trivy)

You can use `trivy` to scan your container images for vulnerabilities. Trivy is a simple and comprehensive vulnerability scanner for containers and other artifacts. A software vulnerability is a glitch, flaw, or weakness present in the software or in an Operating System that could be exploited by an attacker to perform unauthorized actions within the system.

```shell
trivy image nginx:latest
```{{exec}}

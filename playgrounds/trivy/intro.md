![Trivy Icon](https://help.ovhcloud.com/public_cloud-containers_orchestration-managed_kubernetes-installing-trivy-images-trivy-logo.png)

The playground takes some time to be fully ready, please be patient.

# Trivy

The Trivy Operator leverages [Trivy](https://github.com/aquasecurity/trivy) to continuously scan your Kubernetes cluster for security issues. The scans are summarised in security reports as Kubernetes Custom Resource Definitions, which become accessible through the Kubernetes API. The Operator does this by watching Kubernetes for state changes and automatically triggering security scans in response. For example, a vulnerability scan is initiated when a new Pod is created. This way, users can find and view the risks that relate to different resources in a Kubernetes-native way.

# Finishing

When you are done with playing around you can finish the scenario by running clicking `Check`.

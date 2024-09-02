> [Source](https://dev.to/digger/terraform-drift-detection-and-remediation-a-primer-d1)

With the power of managing infrastructure as code, comes the challenge of managing 'drift' - the divergence between the intended state of infrastructure as defined in OpenTofu configurations and its actual state in the infrastructure.

# Tasks

Complete these tasks for this scenario. 

## Task 1: Causes of Drift

The occurrence of drift in OpenTofu-managed infrastructure can be attributed to several factors. A primary cause is manual changes made directly in the infrastructure through interfaces like the AWS Console, which are not recorded in the OpenTofu state file. This discrepancy leads to a state of drift. Another significant factor contributing to drift is the use of multiple automation tools with overlapping capabilities (eg. Ansible).

Often drift is a result of human error, misconfigurations, or changes made outside of the OpenTofu workflow. Eg. in an emergency situation, a quick fix may be applied directly to the infrastructure, bypassing the OpenTofu workflow. This can lead to a state of drift.

## Task 3: Implications of Drift

Drift in OpenTofu can have far-reaching implications. It can expose security vulnerabilities, leading to potential data breaches and system compromises. In terms of compliance, drift can lead to violations, especially when it results in unauthorized access or exposure of sensitive data. Operationally, drift can introduce challenges, increasing system downtime and impacting performance. 

The most significant implication of drift is the loss of control over the infrastructure. It's going to be difficult to get OpenTofu running again in case of duplicated resources or resources that are not managed by OpenTofu.

## Task 4: Remediation of State Drift

There's different approaches to remediate state drift in OpenTofu. Let's like at scenarios where you might have conflicts between desired and actual state. Throughout this scenario we will look at different remediation strategies to address state drift in OpenTofu.

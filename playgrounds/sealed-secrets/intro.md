![Addon Icon](https://github.com/peak-scale/capsule-argo-addon/raw/main/docs/images/capsule-argo.png)

The playground takes some time to be fully ready, please be patient.

# Sealed Secrets

**Problem**: "I can manage all my K8s config in git, except Secrets."

**Solution**: Encrypt your Secret into a SealedSecret, which is safe to store - even inside a public repository. The SealedSecret can be decrypted only by the controller running in the target cluster and nobody else (not even the original author) is able to obtain the original Secret from the SealedSecret.

[See the Source](https://github.com/peak-scale/capsule-argo-addon)

# Finishing

When you are done with playing around you can finish the scenario by running clicking `Check`.

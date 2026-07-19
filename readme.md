# Enterprise Vault Observability (Dynatrace)

This repository contains the Terraform infrastructure-as-code required to deploy a Level A, mission-critical observability platform for HashiCorp Vault using Dynatrace.

## Architecture

This deployment spans three distinct environments and separates monitoring concerns by technology layer:

1. **`vault-ops-a` (Global Synthetic Monitoring)**: External HTTP uptime, seal status, and authentication capability checks across all Vault clusters.
2. **`vault-ops-b` (Docker Infrastructure)**: Deep host-level metrics (CPU, Memory, Network, Disk) and live application logs for Docker-based Vault deployments.
3. **`vault-ops-c` (Kubernetes Infrastructure)**: Deep node-level metrics (CPU, Memory, Network, Disk) and live application logs for Kubernetes-based Vault deployments.

## Secrets Management

This repository adheres to strict zero-trust security principles. **There are absolutely no hardcoded secrets, API tokens, or credentials stored anywhere in this repository.**

All Dynatrace OAuth credentials and API tokens are dynamically fetched at runtime from HashiCorp Vault using the Terraform Vault provider.

### Reading the Secrets
If you are authorized, you can view the underlying Dynatrace credentials used by this repository by running the following Vault command:

```bash
vault kv get secret/dynatrace/automation
```

Example Output:
```text
=========== Data ===========
Key                   Value
---                   -----
api_token             xxxxxxxxxxxxxx
automation_env_url    https://vav17921.apps.dynatrace.com
client_id             xxxxxxxxxxxxxx
client_secret         xxxxxxxxxxxxxx
dt_api_token          xxxxxxxxxxxxxx
dt_env_url            https://vav17921.live.dynatrace.com
```

## Deployment Documentation
For instructions on deploying the Dynatrace OneAgent to the respective Docker and Kubernetes environments, please see the guides located in the `doc/` directory.

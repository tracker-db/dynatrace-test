# Docker OneAgent Deployment

This document outlines the deployment of the Dynatrace OneAgent for Docker environments. Once deployed, the agent automatically monitors the Vault container and reports metrics to the Dynatrace tenant.

## Prerequisites
- SSH access to the target Docker host
- A valid Dynatrace API token (with PaaS token scopes)

## Deployment Instructions

Execute the following Docker command on the target host. This will run the official Dynatrace OneAgent container in privileged mode, mapping to the host's network and process namespace to automatically detect and monitor the Vault container.

Ensure you replace `<YOUR_DYNATRACE_API_TOKEN>` with your actual token before executing.

```bash
docker run -d \
  --restart=unless-stopped \
  --privileged=true \
  --pid=host \
  --net=host \
  -v /:/mnt/root \
  -e ONEAGENT_INSTALLER_SCRIPT_URL="https://vav17921.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=<YOUR_DYNATRACE_API_TOKEN>&arch=x86&flavor=default" \
  dynatrace/oneagent
```

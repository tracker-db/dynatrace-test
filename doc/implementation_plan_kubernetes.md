# Kubernetes Dynatrace Deployment

This document outlines the deployment of the Dynatrace Operator for Kubernetes environments. Once deployed, the Operator automatically injects the OneAgent into the Vault pods and begins reporting metrics to the Dynatrace tenant.

## Prerequisites
- SSH access to the Kubernetes control plane or `kubectl` access to the target cluster
- A valid Dynatrace API token (with PaaS token scopes)
- A valid Dynatrace Data Ingest token

## Deployment Instructions

Execute the following commands on the Kubernetes control plane to deploy the Operator and apply the necessary configuration.

### 1. Install the Dynatrace Operator
First, create the required namespace and install the Operator Custom Resource Definitions (CRDs). Wait approximately 5-10 seconds for the CRDs to fully initialize before proceeding to the next step.

```bash
kubectl create namespace dynatrace
kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes.yaml
```

### 2. Apply the DynaKube Configuration
Apply the following YAML block to configure the `DynaKube` resource. Ensure you replace `<YOUR_DYNATRACE_API_TOKEN>` and `<YOUR_DYNATRACE_DATA_INGEST_TOKEN>` with your actual tokens before executing.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: dynakube
  namespace: dynatrace
type: Opaque
stringData:
  apiToken: "<YOUR_DYNATRACE_API_TOKEN>"
  dataIngestToken: "<YOUR_DYNATRACE_DATA_INGEST_TOKEN>"
---
apiVersion: dynatrace.com/v1beta6
kind: DynaKube
metadata:
  name: dynakube
  namespace: dynatrace
  annotations:
    feature.dynatrace.com/automatic-kubernetes-api-monitoring: "true"
spec:
  apiUrl: "https://vav17921.live.dynatrace.com/api"
  oneAgent:
    cloudNativeFullStack: {}
  activeGate:
    capabilities:
      - routing
      - kubernetes-monitoring
      - metrics-ingest
EOF
```

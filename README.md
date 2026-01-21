# Vault Secrets Operator Workshop

A hands-on workshop demonstrating HashiCorp Vault integration with Kubernetes using the Vault Secrets Operator (VSO).

## Overview

This workshop teaches you how to:

- Configure Kubernetes authentication in Vault
- Sync static secrets from Vault to Kubernetes
- Generate and manage dynamic database credentials
- Use the Vault Secrets Operator to automate secret management

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Jumppad](https://jumppad.dev) installed (v0.5.0 or later)

### Installing Jumppad

```bash
# macOS
brew install jumppad-labs/homebrew-repo/jumppad

# Linux
curl -s https://jumppad.dev/install | bash
```

## Running Locally

### Start the Environment

```bash
jumppad up ./jumppad
```

This will create:
- A K3s Kubernetes cluster
- A Vault server (dev mode) at `http://localhost:8200`
- A PostgreSQL database
- The Vault Secrets Operator installed in the cluster
- An interactive documentation server

### Access the Workshop

Once the environment is running:

| Service | URL |
|---------|-----|
| Workshop Docs | http://localhost:80 |
| VSCode (Web IDE) | http://localhost:8000 |
| Vault UI | http://localhost:8200 |

### Export Environment Variables

To interact with the environment from your local terminal:

```bash
eval $(jumppad env)
```

This exports:
- `KUBECONFIG` - Path to the Kubernetes config
- `VAULT_ADDR` - Vault server address (`http://localhost:8200`)
- `VAULT_TOKEN` - Vault root token (`root`)

### Verify the Setup

```bash
# Check Vault status
vault status

# Check Kubernetes cluster
kubectl get nodes

# Verify VSO is running
kubectl get pods -n vault-secrets-operator
```

## Workshop Structure

The workshop is divided into chapters:

1. **Introduction** - Overview of Vault and the Secrets Operator
2. **Authentication** - Configure Kubernetes auth method in Vault
3. **Static Secrets** - Sync KV secrets to Kubernetes
4. **Dynamic Secrets** - Generate database credentials on-demand

## Environment Details

| Component | Details |
|-----------|---------|
| Vault | v1.18 (dev mode) |
| Kubernetes | K3s |
| Vault Secrets Operator | v0.10.0 |
| PostgreSQL | v16 |

### Network Configuration

| Service | IP Address |
|---------|------------|
| Vault | 10.100.0.200 |
| PostgreSQL | 10.100.0.201 |

## Cleanup

To stop and remove all resources:

```bash
jumppad down
```

## Troubleshooting

### Vault Connection Issues

Ensure Vault is running and accessible:

```bash
curl http://localhost:8200/v1/sys/health
```

### Kubernetes Issues

Check the cluster status:

```bash
kubectl cluster-info
kubectl get pods -A
```

### VSO Not Syncing Secrets

Check the operator logs:

```bash
kubectl logs -n vault-secrets-operator -l app.kubernetes.io/name=vault-secrets-operator
```

## License

This workshop is provided for educational purposes.

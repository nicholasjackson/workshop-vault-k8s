# Chapter Planning Document

This document outlines the process and flow for the Static Secrets and Dynamic Secrets chapters, including the tasks that need to be created.

---

## Static Secrets Chapter

### Overview

This chapter teaches users how to sync static KV secrets from Vault to Kubernetes using the Vault Secrets Operator (VSO).

### Prerequisites

- Kubernetes authentication configured in Vault (from Authentication chapter)

### Pages and Tasks

1. **Overview** (overview.mdx) - **COMPLETE**
   - [x] Introduction to static secrets
   - [x] When to use static secrets
   - [x] Explanation of KV secrets engine (v1 vs v2)

2. **Working with Secrets** (working_with_secrets.mdx) - **COMPLETE**
   - [x] Understanding secret paths
   - [x] Creating secrets with `vault kv put`
   - [x] Reading secrets with `vault kv get`
   - [x] Updating secrets and versioning

3. **Creating a Policy and Role** (policy_and_role.mdx) - **COMPLETE**
   - [x] Understanding Vault policies
   - [x] The `/data/` path for KV v2
   - [x] Creating the demo-policy
   - [x] Creating the Kubernetes auth role

4. **Creating the Service Account** (service_account.mdx) - **COMPLETE**
   - [x] Why service accounts are needed
   - [x] Service account tokens (pre/post K8s 1.24)
   - [x] Creating the demo-app service account and token secret

5. **Testing Authentication** (test_authentication.mdx) - **COMPLETE**
   - [x] The authentication flow explained
   - [x] Extracting the service account JWT
   - [x] Authenticating with `vault write auth/kubernetes/login`
   - [x] Reading the secret with the obtained token
   - [x] Troubleshooting tips

6. **Configuring the Vault Secrets Operator** (vault_auth.mdx) - **COMPLETE**
   - [x] VaultConnection resource
   - [x] VaultAuth resource
   - [x] Verifying configuration

7. **Creating a VaultStaticSecret** (vault_static_secret.mdx) - **EXISTS** (needs review)
   - [x] VaultStaticSecret resource explained
   - [x] Apply the configuration
   - [x] Verify the secret sync
   - [ ] Update secret in Vault and observe sync

---

## Dynamic Secrets Chapter

### Overview

This chapter teaches users how to use Vault's database secrets engine to generate dynamic PostgreSQL credentials that automatically rotate, and sync them to Kubernetes using the Vault Secrets Operator (VSO).

### Prerequisites

- Kubernetes authentication configured in Vault (from Authentication chapter)
- VaultAuth configured (from Static Secrets chapter)
- PostgreSQL database running

### Pages and Tasks

1. **Overview** (overview.mdx) - **PENDING**
   - [ ] Introduction to dynamic secrets
   - [ ] Benefits over static secrets
   - [ ] How dynamic credentials work

2. **Working with the Database Engine** (database_engine.mdx) - **PENDING**
   - [ ] Enable the database secrets engine
   - [ ] Configure the PostgreSQL connection
   - [ ] Create a database role with creation statements
   - [ ] Test generating credentials manually

3. **Updating Policy and Role** (update_policy.mdx) - **PENDING**
   - [ ] Update demo-policy to allow database credential access
   - [ ] Test authentication can retrieve database credentials

4. **Creating a VaultDynamicSecret** (vault_dynamic_secret.mdx) - **EXISTS** (needs review)
   - [ ] VaultDynamicSecret resource explained
   - [ ] Apply the configuration
   - [ ] Observe credential rotation
   - [ ] Verify credentials work with PostgreSQL
   - [ ] Test lease revocation

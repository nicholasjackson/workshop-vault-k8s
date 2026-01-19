#!/bin/bash
set -euo pipefail

# Wait for Vault to be ready
until vault status > /dev/null 2>&1; do
  echo "Waiting for Vault to be ready..."
  sleep 2
done

echo "Vault is ready!"

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h localhost -p 5432 -U postgres > /dev/null 2>&1; do
  sleep 2
done

echo "PostgreSQL is ready!"

# Enable the database secrets engine
echo "Enabling database secrets engine..."
vault secrets enable database || true

# Configure the PostgreSQL connection
# Using the container's network IP for Vault to reach PostgreSQL
echo "Configuring PostgreSQL connection..."
vault write database/config/demo-db \
  plugin_name="postgresql-database-plugin" \
  allowed_roles="demo-role" \
  connection_url="postgresql://{{username}}:{{password}}@10.10.0.201:5432/demo?sslmode=disable" \
  username="postgres" \
  password="postgres"

# Create a role for dynamic credentials
echo "Creating database role..."
vault write database/roles/demo-role \
  db_name="demo-db" \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="60s" \
  max_ttl="120s"

# Update the demo-app policy to include database credentials
echo "Updating demo-app policy..."
vault policy write demo-app - <<EOF
path "secret/data/demo/*" {
  capabilities = ["read", "list"]
}

path "database/creds/demo-role" {
  capabilities = ["read"]
}
EOF

echo ""
echo "Database secrets engine configured!"
echo ""
echo "To test dynamic credentials:"
echo "  vault read database/creds/demo-role"
echo ""
echo "To apply the Kubernetes dynamic secret:"
echo "  kubectl apply -f k8s/vault-dynamic-secret.yaml"

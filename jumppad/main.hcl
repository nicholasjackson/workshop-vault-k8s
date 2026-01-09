resource "network" "main" {
  subnet = "10.5.0.0/16"
}

resource "k8s_cluster" "k3s" {
  network {
    id = resource.network.main.meta.id
  }
}

resource "container" "vault" {
  image {
    name = "hashicorp/vault:1.18"
  }

  command = [
    "vault",
    "server",
    "-dev",
    "-dev-root-token-id=root",
    "-dev-listen-address=0.0.0.0:8200"
  ]

  network {
    id         = resource.network.main.meta.id
    ip_address = "10.5.0.200"
  }

  environment = {
    VAULT_DEV_ROOT_TOKEN_ID = "root"
  }

  port {
    local  = 8200
    remote = 8200
    host   = 8200
  }
}

resource "container" "postgres" {
  image {
    name = "postgres:16"
  }

  network {
    id         = resource.network.main.meta.id
    ip_address = "10.5.0.201"
  }

  environment = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "demo"
  }

  port {
    local  = 5432
    remote = 5432
    host   = 5432
  }
}

resource "helm" "vault_secrets_operator" {
  cluster = resource.k8s_cluster.k3s

  repository {
    name = "hashicorp"
    url  = "https://helm.releases.hashicorp.com"
  }

  chart            = "hashicorp/vault-secrets-operator"
  version          = "0.10.0"
  namespace        = "vault-secrets-operator"
  create_namespace = true

  values_string = {
    "defaultVaultConnection.enabled" = "true"
    "defaultVaultConnection.address" = "http://${resource.container.vault.network[0].assigned_address}:8200"
  }

  health_check {
    timeout = "120s"
    pods    = ["app.kubernetes.io/name=vault-secrets-operator"]
  }
}

// Use 'eval $(jumppad env)' to export these variables to your shell
output "KUBECONFIG" {
  value = resource.k8s_cluster.k3s.kube_config.path
}

output "VAULT_ADDR" {
  value = "http://localhost:8200"
}

output "VAULT_TOKEN" {
  value = "root"
}

output "POSTGRES_HOST" {
  value = "localhost"
}

output "POSTGRES_PORT" {
  value = "5432"
}

output "POSTGRES_USER" {
  value = "postgres"
}

output "POSTGRES_PASSWORD" {
  value = "postgres"
}

output "POSTGRES_DB" {
  value = "demo"
}

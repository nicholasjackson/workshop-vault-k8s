variable "docs_url" {
  default = "http://localhost:8080"
}

variable "vscode_token" {
  default = "token"
}

variable "vault_token" {
  default = "root"
}

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
    "-dev-root-token-id=${variable.vault_token}",
    "-dev-listen-address=0.0.0.0:8200"
  ]

  network {
    id         = resource.network.main.meta.id
    ip_address = "10.5.0.200"
  }

  environment = {
    VAULT_DEV_ROOT_TOKEN_ID = variable.vault_token
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
    local = 5432
    host  = 5432
  }
}

module "docs" {
  source = "./docs"
}

resource "docs" "docs" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "ghcr.io/jumppad-labs/docs:v0.5.1"
  }

  port = 8080

  content = [
    module.docs.output.book
  ]
}

resource "template" "vscode_jumppad" {
  source      = <<-EOF
  {
  "tabs": [
    {
      "name": "Docs",
      "uri": "${variable.docs_url}",
      "type": "browser",
      "active": true
    },
    {
      "name": "Terminal",
      "location": "editor",
      "type": "terminal"
    }
  ]
  }
  EOF
  destination = "${data("vscode")}/workspace.json"
}

resource "container" "vscode" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "ghcr.io/nicholasjackson/workshop-vault-k8s:v0.1.0"
  }

  port {
    local = 8000
    host  = 8000
  }

  volume {
    source      = "../workspace/k8s"
    destination = "/workspace/k8s"
  }

  volume {
    source      = resource.template.vscode_jumppad.destination
    destination = "/workspace/k8s/.vscode/workspace.json"
  }

  volume {
    source      = resource.k8s_cluster.k3s.kube_config.path
    destination = "/workspace/.kube/config"
  }

  environment = {
    KUBECONFIG       = "/workspace/.kube/config"
    VAULT_TOKEN      = variable.vault_token
    VAULT_ADDR       = "http://vault.container.local.jmpd.in:8200"
    CONNECTION_TOKEN = variable.vscode_token
    DEFAULT_FOLDER   = "/workspace/k8s"
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

variable "network" {
  default = ""
}

resource "book" "vault_k8s" {
  title = "Vault Secrets Operator Workshop"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.static_secrets,
    resource.chapter.dynamic_secrets,
  ]
}

resource "chapter" "introduction" {
  title = "Introduction"

  tasks = {}

  page "overview" {
    content = file("./introduction/overview.mdx")
  }

  page "architecture" {
    content = file("./introduction/architecture.mdx")
  }

  page "setup" {
    content = file("./introduction/setup.mdx")
  }
}

resource "chapter" "static_secrets" {
  title = "Static Secrets"

  tasks = {}

  page "overview" {
    content = file("./static_secrets/overview.mdx")
  }

  page "vault_auth" {
    content = file("./static_secrets/vault_auth.mdx")
  }

  page "vault_static_secret" {
    content = file("./static_secrets/vault_static_secret.mdx")
  }
}

resource "chapter" "dynamic_secrets" {
  title = "Dynamic Secrets"

  tasks = {}

  page "overview" {
    content = file("./dynamic_secrets/overview.mdx")
  }

  page "database_engine" {
    content = file("./dynamic_secrets/database_engine.mdx")
  }

  page "vault_dynamic_secret" {
    content = file("./dynamic_secrets/vault_dynamic_secret.mdx")
  }
}

output "book" {
  value = resource.book.vault_k8s
}

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

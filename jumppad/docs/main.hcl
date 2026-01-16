variable "target" {
  default = "resource.container.vscode"
}

resource "book" "vault_k8s" {
  title = "Vault Secrets Operator Workshop"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.authentication,
    resource.chapter.static_secrets,
    resource.chapter.dynamic_secrets,
  ]
}

output "book" {
  value = resource.book.vault_k8s
}

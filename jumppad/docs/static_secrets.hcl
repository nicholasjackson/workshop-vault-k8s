resource "task" "working_with_secrets" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "secret_created" {
    description = "Create a secret in Vault"

    check {
      script          = file("./static_secrets/checks/secret_created.sh")
      failure_message = "The secret at secret/demo/config was not created"
    }

    solve {
      script = file("./static_secrets/checks/solve_secret_created.sh")
    }
  }

  condition "secret_retrieved" {
    description = "Retrieve the secret from Vault"

    check {
      script          = file("./static_secrets/checks/secret_retrieved.sh")
      failure_message = "The secret was not retrieved using vault kv get"
    }
  }

  condition "secret_updated" {
    description = "Update the secret in Vault"

    check {
      script          = file("./static_secrets/checks/secret_updated.sh")
      failure_message = "The secret was not updated (version should be > 1)"
    }

    solve {
      script = file("./static_secrets/checks/solve_secret_updated.sh")
    }
  }
}

resource "task" "create_policy_and_role" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "policy_created" {
    description = "Create the Vault policy"

    check {
      script          = file("./static_secrets/checks/policy_created.sh")
      failure_message = "The demo-policy was not created in Vault"
    }

    solve {
      script = file("./static_secrets/checks/solve_policy_created.sh")
    }
  }

  condition "role_created" {
    description = "Create the Kubernetes auth role"

    check {
      script          = file("./static_secrets/checks/role_created.sh")
      failure_message = "The demo-app role was not created in Vault"
    }

    solve {
      script = file("./static_secrets/checks/solve_role_created.sh")
    }
  }
}

resource "task" "create_service_account" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "service_account_created" {
    description = "Create the Kubernetes service account"

    check {
      script          = file("./static_secrets/checks/service_account_created.sh")
      failure_message = "The demo-app service account was not created"
    }

    solve {
      script = file("./static_secrets/checks/solve_service_account_created.sh")
    }
  }

  condition "token_secret_created" {
    description = "Create the service account token secret"

    check {
      script          = file("./static_secrets/checks/token_secret_created.sh")
      failure_message = "The demo-app-token secret was not created"
    }
  }
}

resource "task" "test_authentication" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "auth_tested" {
    description = "Test authentication with Vault"

    check {
      script          = file("./static_secrets/checks/auth_tested.sh")
      failure_message = "Authentication test was not completed"
    }

    solve {
      script = file("./static_secrets/checks/solve_auth_tested.sh")
    }
  }
}

resource "task" "configure_vso" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "vault_connection_created" {
    description = "Create the VaultConnection resource"

    check {
      script          = file("./static_secrets/checks/vault_connection_created.sh")
      failure_message = "The VaultConnection resource was not created"
    }

    solve {
      script = file("./static_secrets/checks/solve_vault_connection_created.sh")
    }
  }

  condition "vault_auth_created" {
    description = "Create the VaultAuth resource"

    check {
      script          = file("./static_secrets/checks/vault_auth_created.sh")
      failure_message = "The VaultAuth resource was not created"
    }

    solve {
      script = file("./static_secrets/checks/solve_vault_auth_created.sh")
    }
  }
}

resource "task" "create_static_secret" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "static_secret_created" {
    description = "Create the VaultStaticSecret resource"

    check {
      script          = file("./static_secrets/checks/static_secret_created.sh")
      failure_message = "The VaultStaticSecret resource was not created"
    }

    solve {
      script = file("./static_secrets/checks/solve_static_secret_created.sh")
    }
  }

  condition "k8s_secret_synced" {
    description = "Verify the Kubernetes secret was synced"

    check {
      script          = file("./static_secrets/checks/k8s_secret_synced.sh")
      failure_message = "The Kubernetes secret was not synced from Vault"
    }
  }
}

resource "chapter" "static_secrets" {
  title = "Static Secrets"

  tasks = {
    working_with_secrets  = resource.task.working_with_secrets
    create_policy_and_role = resource.task.create_policy_and_role
    create_service_account = resource.task.create_service_account
    test_authentication    = resource.task.test_authentication
    configure_vso          = resource.task.configure_vso
    create_static_secret   = resource.task.create_static_secret
  }

  page "overview" {
    content = file("./static_secrets/overview.mdx")
  }

  page "working_with_secrets" {
    content = file("./static_secrets/working_with_secrets.mdx")
  }

  page "policy_and_role" {
    content = file("./static_secrets/policy_and_role.mdx")
  }

  page "service_account" {
    content = file("./static_secrets/service_account.mdx")
  }

  page "test_authentication" {
    content = file("./static_secrets/test_authentication.mdx")
  }

  page "vault_auth" {
    content = file("./static_secrets/vault_auth.mdx")
  }

  page "vault_static_secret" {
    content = file("./static_secrets/vault_static_secret.mdx")
  }
}

resource "task" "configure_database_engine" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "database_engine_enabled" {
    description = "Enable the database secrets engine"

    check {
      script          = file("./dynamic_secrets/checks/database_engine_enabled.sh")
      failure_message = "The database secrets engine is not enabled"
    }

    solve {
      script = file("./dynamic_secrets/checks/solve_database_engine_enabled.sh")
    }
  }

  condition "database_configured" {
    description = "Configure the PostgreSQL connection"

    check {
      script          = file("./dynamic_secrets/checks/database_configured.sh")
      failure_message = "The PostgreSQL connection was not configured in Vault"
    }

    solve {
      script = file("./dynamic_secrets/checks/solve_database_configured.sh")
    }
  }
}

resource "task" "create_database_role" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "database_role_created" {
    description = "Create the database role"

    check {
      script          = file("./dynamic_secrets/checks/database_role_created.sh")
      failure_message = "The demo-role was not created in the database secrets engine"
    }

    solve {
      script = file("./dynamic_secrets/checks/solve_database_role_created.sh")
    }
  }

  condition "policy_updated" {
    description = "Update the policy to include database credentials"

    check {
      script          = file("./dynamic_secrets/checks/policy_updated.sh")
      failure_message = "The demo-app policy does not include database credentials path"
    }

    solve {
      script = file("./dynamic_secrets/checks/solve_policy_updated.sh")
    }
  }

}

resource "task" "create_dynamic_secret" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "dynamic_secret_created" {
    description = "Create the VaultDynamicSecret resource"

    check {
      script          = file("./dynamic_secrets/checks/dynamic_secret_created.sh")
      failure_message = "The VaultDynamicSecret resource was not created"
    }

    solve {
      script = file("./dynamic_secrets/checks/solve_dynamic_secret_created.sh")
    }
  }

  condition "k8s_dynamic_secret_synced" {
    description = "Verify the Kubernetes secret was synced"

    check {
      script          = file("./dynamic_secrets/checks/k8s_dynamic_secret_synced.sh")
      failure_message = "The Kubernetes secret was not synced from Vault"
    }
  }
}

resource "chapter" "dynamic_secrets" {
  title = "Dynamic Secrets"

  tasks = {
    configure_database_engine = resource.task.configure_database_engine
    create_database_role      = resource.task.create_database_role
    create_dynamic_secret     = resource.task.create_dynamic_secret
  }

  page "overview" {
    content = file("./dynamic_secrets/overview.mdx")
  }

  page "database_engine" {
    content = file("./dynamic_secrets/database_engine.mdx")
  }

  page "database_role" {
    content = file("./dynamic_secrets/database_role.mdx")
  }

  page "test_credentials" {
    content = file("./dynamic_secrets/test_credentials.mdx")
  }

  page "vault_dynamic_secret" {
    content = file("./dynamic_secrets/vault_dynamic_secret.mdx")
  }
}

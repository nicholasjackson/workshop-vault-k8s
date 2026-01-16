resource "task" "configure_auth" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "enable_auth" {
    description = "Configure the Kubernetes authentication method for Vault"

    check {
      script          = file("./authentication/checks/auth_enabled.sh")
      failure_message = "The Kubernetes authentication method was not enabled"
    }

    solve {
      script = file("./authentication/checks/solve_auth_enabled.sh")
    }
  }
}

resource "task" "token_create" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "create_token" {
    description = "Configure the service account token for Vault"

    check {
      script          = file("./authentication/checks/token_created.sh")
      failure_message = "The Kubernetes service account token was not created"
    }

    solve {
      script = file("./authentication/checks/solve_token_created.sh")
    }
  }
}

resource "task" "configure_vault" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.target
  }

  condition "get_host" {
    description = "Fetch the Kubernetes host address"

    check {
      script          = file("./authentication/checks/get_k8s_host.sh")
      failure_message = "The host address was not set"
    }

    solve {
      script = file("./authentication/checks/solve_get_k8s_host.sh")
    }
  }

  condition "get_ca_cert" {
    description = "Fetch the Kubernetes CA Certificate"

    check {
      script          = file("./authentication/checks/get_ca_cert.sh")
      failure_message = "The Kubernetes CA certificate was not set"
    }
  }

  condition "get_token_reviewer_jwt" {
    description = "Fetch the token reviewer jwt"

    check {
      script          = file("./authentication/checks/get_token_jwt.sh")
      failure_message = "The Kubernetes service account token was not set"
    }
  }

  condition "apply_config" {
    description = "Configure the Kubernetes authentication mount"

    check {
      script          = file("./authentication/checks/set_config.sh")
      failure_message = "The config was not set"
    }
  }
}

resource "chapter" "authentication" {
  title = "Enabling Kubernetes Authentication"

  tasks = {
    configure_auth  = resource.task.configure_auth
    create_token    = resource.task.token_create
    configure_vault = resource.task.configure_vault
  }

  page "setup" {
    content = file("./authentication/setup.mdx")
  }

  page "enabling_auth" {
    content = file("./authentication/enable_auth_method.mdx")
  }

  page "create_token_reviewer" {
    content = file("./authentication/create_token_reviewer.mdx")
  }

  page "configure_auth" {
    content = file("./authentication/configure_auth.mdx")
  }
}

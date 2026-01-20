variable "jumppad_version" {
  type = string
}

variable "project_name" {
  type = string
}

variable "git_repo" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west4-a"
}

packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "jumppad" {
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  image_family = "jumppad"
  image_name   = regex_replace("workshop-${var.project_name}-${var.jumppad_version}-5", "[^a-zA-Z0-9_-]", "-")

  source_image_family = "ubuntu-2204-lts"
  machine_type        = "n1-standard-4"
  disk_size           = 20

  ssh_username = "root"
}

build {
  sources = ["source.googlecompute.jumppad"]

  provisioner "file" {
    source      = "files"
    destination = "/tmp/resources"
  }

  provisioner "shell" {
    script = "files/install.sh"
    environment_vars = [
      "JUMPPAD_VERSION=${trimprefix(var.jumppad_version, "v")}",
      "GIT_REPO=${var.git_repo}",
    ]
  }
}
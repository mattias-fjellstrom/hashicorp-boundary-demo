terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }

    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.14"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.4"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "4.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "boundary" {
  addr                   = var.boundary_cluster_url
  auth_method_login_name = var.boundary_admin_username
  auth_method_password   = var.boundary_admin_password
}

provider "vault" {
  address   = var.vault_cluster_url
  namespace = "admin"
  token     = var.vault_admin_token
}

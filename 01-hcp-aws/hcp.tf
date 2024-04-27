# NETWORKING -------------------------------------------------------------------
resource "hcp_hvn" "this" {
  hvn_id         = "hvn-aws-${var.aws_region}"
  cidr_block     = var.hvn_cidr_block
  cloud_provider = "aws"
  region         = var.aws_region
}

# BOUNDARY ---------------------------------------------------------------------
resource "hcp_boundary_cluster" "this" {
  cluster_id = "aws-cluster"
  username   = var.boundary_admin_username
  password   = var.boundary_admin_password
  tier       = "Plus"

  maintenance_window_config {
    day          = "MONDAY"
    start        = 2
    end          = 8
    upgrade_type = "SCHEDULED"
  }
}

# VAULT ------------------------------------------------------------------------
resource "hcp_vault_cluster" "this" {
  cluster_id      = "vault-aws-${var.aws_region}"
  hvn_id          = hcp_hvn.this.hvn_id
  tier            = "dev"
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "this" {
  cluster_id = hcp_vault_cluster.this.cluster_id
}

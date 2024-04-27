resource "boundary_credential_store_vault" "ec2" {
  name      = "boudary-vault-credential-store-ec2"
  scope_id  = boundary_scope.project.id
  address   = var.vault_cluster_url
  token     = vault_token.boundary.client_token
  namespace = "admin"
}

resource "boundary_credential_library_vault_ssh_certificate" "ec2" {
  name                = "ssh-certificates"
  credential_store_id = boundary_credential_store_vault.ec2.id
  path                = "ssh-client-signer/sign/boundary-client"
  username            = "ubuntu"
  key_type            = "ecdsa"
  key_bits            = 521
  extensions = {
    permit-pty = ""
  }
}

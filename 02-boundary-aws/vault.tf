resource "vault_policy" "boundary" {
  name   = "boundary-controller"
  policy = file("./policy/boundary-controller-policy.hcl")
}

resource "vault_policy" "ssh" {
  name   = "ssh"
  policy = file("./policy/ssh-policy.hcl")
}

resource "vault_mount" "ssh" {
  path = "ssh-client-signer"
  type = "ssh"
}

resource "vault_ssh_secret_backend_role" "boundary_client" {
  name                    = "boundary-client"
  backend                 = vault_mount.ssh.path
  key_type                = "ca"
  default_user            = "ubuntu"
  allowed_users           = "*"
  allowed_extensions      = "*"
  allow_host_certificates = true
  allow_user_certificates = true

  default_extensions = {
    permit-pty = ""
  }
}

resource "vault_ssh_secret_backend_ca" "boundary" {
  backend              = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_token" "boundary" {
  display_name = "boundary"
  policies = [
    vault_policy.boundary.name,
    vault_policy.ssh.name,
  ]
  no_default_policy = true
  no_parent         = true
  renewable         = true
  ttl               = "24h"
  period            = "1h"
}

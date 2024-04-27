# JOHN ON-CALL ENGINEER ------------------------------------------------------------------------------------------------
resource "random_password" "john" {
  length  = 32
  lower   = true
  upper   = true
  numeric = true
  special = false
}

resource "boundary_account_password" "john" {
  name           = "john"
  login_name     = "john"
  description    = "John account for the password auth method"
  password       = random_password.john.result
  auth_method_id = data.boundary_auth_method.password.id
}

resource "boundary_user" "john" {
  name        = "John Doe"
  description = "John the on-call engineer"
  scope_id    = "global"
  account_ids = [
    boundary_account_password.john.id,
  ]
}

# JANE ON-CALL ENGINEER ------------------------------------------------------------------------------------------------
resource "random_password" "jane" {
  length  = 32
  lower   = true
  upper   = true
  numeric = true
  special = false
}

resource "boundary_account_password" "jane" {
  name           = "jane"
  login_name     = "jane"
  description    = "Jane account for the password auth method"
  password       = random_password.jane.result
  auth_method_id = data.boundary_auth_method.password.id
}

resource "boundary_user" "jane" {
  name        = "Jane Doe"
  description = "Jane the on-call engineer"
  scope_id    = "global"
  account_ids = [
    boundary_account_password.jane.id,
  ]
}

# AWS LAMBDA USER ------------------------------------------------------------------------------------------------------
resource "random_password" "lambda" {
  length  = 32
  lower   = true
  upper   = true
  numeric = true
  special = false
}

resource "boundary_account_password" "lambda" {
  name           = "lambda"
  login_name     = "lambda"
  description    = "Account for AWS Lambda in the password auth method"
  password       = random_password.lambda.result
  auth_method_id = data.boundary_auth_method.password.id
}

resource "boundary_user" "lambda" {
  name        = "AWS Lambda"
  description = "User for AWS Lambda"
  scope_id    = "global"
  account_ids = [
    boundary_account_password.lambda.id,
  ]
}

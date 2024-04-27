resource "boundary_role" "reader" {
  name        = "reader"
  description = "Custom reader role for on-call engineers"
  scope_id    = boundary_scope.org.id
  grant_scope_ids = [
    boundary_scope.org.id,
    boundary_scope.project.id,
  ]
  grant_strings = [
    "ids=*;type=*;actions=list,no-op",
    "ids=*;type=auth-token;actions=list,read:self,delete:self"
  ]
  principal_ids = [
    boundary_user.jane.id,
    boundary_user.john.id,
  ]
}

resource "boundary_role" "alert" {
  name        = "alert"
  description = "Custom role for on-call engineers during alerts"
  scope_id    = "global"
  grant_scope_ids = [
    boundary_scope.org.id,
    boundary_scope.project.id,
  ]
  grant_strings = [
    "ids=*;type=*;actions=read,list",
    "ids=*;type=target;actions=authorize-session"
  ]
}

resource "boundary_role" "lambda" {
  name        = "lambda"
  description = "Custom role for AWS Lambda to administer the on-call role assignments"
  scope_id    = "global"
  grant_strings = [
    "ids=*;type=*;actions=list,no-op",
    "ids=${boundary_role.alert.id};type=role;actions=read,list,add-principals,remove-principals",
  ]
  grant_scope_ids = [
    "global",
    boundary_scope.org.id,
    boundary_scope.project.id,
  ]
  principal_ids = [
    boundary_user.lambda.id,
  ]
}

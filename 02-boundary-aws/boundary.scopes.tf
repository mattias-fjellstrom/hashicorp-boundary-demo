resource "boundary_scope" "org" {
  name                     = "demo-organization"
  description              = "Organization for blog post demo"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "project" {
  name                     = "aws-resources"
  description              = "Project for target AWS resources"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

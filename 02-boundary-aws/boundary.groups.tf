resource "boundary_group" "oncall" {
  name        = "on-call-engineers"
  description = "On-call engineers"
  scope_id    = "global"
  member_ids = [
    boundary_user.john.id,
    boundary_user.jane.id,
  ]
}

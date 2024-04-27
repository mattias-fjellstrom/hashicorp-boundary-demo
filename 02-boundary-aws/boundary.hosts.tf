
resource "boundary_host_catalog_static" "ec2" {
  name        = "AWS Static Host Catalog"
  description = "EC2 instances"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "ec2" {
  name            = "aws-ec2-static-host"
  address         = aws_instance.ec2.public_ip
  host_catalog_id = boundary_host_catalog_static.ec2.id
}

resource "boundary_host_set_static" "ec2" {
  name            = "aws-ec2-static-host-set"
  host_catalog_id = boundary_host_catalog_static.ec2.id
  host_ids = [
    boundary_host_static.ec2.id,
  ]
}

output "hcp_boundary_cluster_url" {
  description = "HCP Boundary cluster URL"
  value       = hcp_boundary_cluster.this.cluster_url
}

output "hcp_vault_cluster_public_url" {
  description = "HCP Vault public endpoint URL"
  value       = hcp_vault_cluster.this.vault_public_endpoint_url
}

output "aws_vpc_id" {
  description = "AWS VPC ID"
  value       = aws_vpc.this.id
}

output "aws_subnet_id" {
  description = "AWS subnet ID"
  value       = aws_subnet.public.id
}

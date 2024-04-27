variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "eu-west-1"
}

variable "aws_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "aws_subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "boundary_cluster_url" {
  description = "HCP Boundary cluster URL"
  type        = string
}

variable "boundary_admin_username" {
  description = "Boundary administrator username"
  type        = string
}

variable "boundary_admin_password" {
  description = "Boundary administrator password"
  type        = string
  sensitive   = true
}

variable "vault_cluster_url" {
  description = "HCP Vault cluster URL"
  type        = string
}

variable "vault_admin_token" {
  description = "Vault admin token"
  type        = string
  sensitive   = true
}

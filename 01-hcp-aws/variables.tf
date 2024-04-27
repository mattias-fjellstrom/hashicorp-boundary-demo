variable "aws_vpc_cidr_block" {
  description = "CIDR block for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_public_subnet_cidr_block" {
  description = "CIDR block for the public subnet in AWS"
  type        = string
  default     = "10.0.10.0/24"
}

variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "eu-west-1"
}

variable "boundary_admin_username" {
  description = "Boundary admin username"
  type        = string
}

variable "boundary_admin_password" {
  description = "Boundary admin user password"
  type        = string
  sensitive   = true
}

variable "hvn_cidr_block" {
  description = "CIDR block for the HashiCorp Virtual Network with Vault"
  type        = string
  default     = "192.168.100.0/24"
}

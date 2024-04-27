# Instructions

## Prerequisites

Make sure you have deployed the infrastructure in [01-hcp-aws](../01-hcp-aws/) before you proceed.

## Steps

Create a `main.auto.tfvars` file with the following content:

```hcl
boundary_cluster_url = "<output from 01-hcp-aws>"
aws_subnet_id        = "<output from 01-hcp-aws>"
aws_vpc_id           = "<output from 01-hcp-aws>"
vault_cluster_url    = "<output from 01-hcp-aws>"

boundary_admin_username = "<same value you used in 01-hcp-aws>"
boundary_admin_password = "<same value you used in 01-hcp-aws>"
aws_region              = "<same value you used in 01-hcp-aws>"

vault_admin_token    = "<grab the generated token from the state file for 01-hcp-aws>"
```

Create the infrastructure with `terraform apply`.
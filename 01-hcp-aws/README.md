# Instructions

## Prerequisites

- AWS credentials with sufficient permissions to create VPC resources available as environment variables or configured as a profile in the AWS CLI
- HCP organization and a default project set up and authenticated (authentication is triggered automatically during setup)

## Steps

Create a `main.auto.tfvars` file with the following content:

```hcl
aws_region              = "<select your favorite aws region>"
boundary_admin_username = "<pick an administrator username for boundary>"
boundary_admin_password = "<pick an administrator password for boundary>"
```

Create the infrastructure with `terraform apply`.
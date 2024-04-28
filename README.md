This repository contains the sample code for the blog article at [https://mattias.engineer/posts/hcp-boundary/](https://mattias.engineer/posts/hcp-boundary/).

In essence the Terraform configuration in this repository sets up HCP Boundary and HCP Vault and a target resource in AWS. Access for the target resource is configured as needed when an alert triggers a Lambda function that adds a Boundary group to a Boundary role, allowing on-call engineers to access targets during issues.

Read the blog post for the full description.

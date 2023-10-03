# DAY 0 Network Deployment

## Description
This module includes the networking setup, including VPC provisions, Subnet creation and provisions, AWS network firewall policies, and other various network components.

FedRAMP Compliance: Moderate, High

## Dependencies
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Resource List
A high-level list of resources created as a part of this module.
- VPC
- Subnets
  - Public
  - Private
  - Firewall
  - Compute
- IAM Roles
- IAM Policies
- KMS Keys

## Code Updates
terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
}
  backend "s3" {
    bucket         = "ooc-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "ooc-us-gov-west-1-networking.tfstate"
    dynamodb_table = "ooc-us-gov-west-1-state-lock"
    encrypt        = true
  }
}

## tfvars Example
``` hcl
resource_prefix = "<customer-prefix>"
deploy_aws_nfw = true
aws_region = "<aws-region>"
cidrs_for_remote_access = ["<Customer-IP>"]
mgmt_vpc_cidr = "<Customer-Custom-CIDR-Range"
profile = "<customer-prefix>-mgmt"
```

## Deployment Steps
- Change the working directory the `networking` folder
- If you are running this directory for the first time, comment out the S3 backend in `tstate.tf`
  - From in front of `backend "s3"` to the bracket associated with the end of the code block
- Run `terraform init`
- Run `terraform plan` to review the resources being created
- If everything looks correct in the plan output, run `terraform apply`

``` hcl
data "terraform_remote_state" "day0" {
  backend = "s3"

  config = {
    bucket  = "ooc-<aws-region>-tf-state"
    region  = var.aws_region
    key     = "ooc-<aws-region>-tfsetup.tfstate"
    profile = "ooc-mgmt"
  }
}
```
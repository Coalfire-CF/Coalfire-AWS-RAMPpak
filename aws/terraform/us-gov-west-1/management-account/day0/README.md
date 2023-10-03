# DAY 0 Deployment Management Account 

## Description
This module provisions the management account setup, including initial account confirguations, IAM roles, KMS keys, S3 bucket installs, etc.

FedRAMP Compliance: High

## Dependencies
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Resource List
A high-level list of resources created as a part of this module.
- IAM Roles
- IAM Policies
- IAM instance profiles
- KMS Keys
- S3 buckets
- Region Setup
- Security Core Module Resources

## Code Updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample
``` hcl
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
    key            = "ooc-us-gov-west-1-tfsetup.tfstate"
    dynamodb_table = "ooc-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```

## tfvars Example
``` hcl
resource_prefix = "<customer-prefix>"
aws_region = "<aws-region>"
```

## Deployment Steps
- Change the working directory to the `management-account` directory
- If you are running this directory for the first time, comment out the S3 backend in `tstate.tf`
  - From in front of `backend "s3"` to the bracket associated with the end of the code block
- Run `terraform init`
- Run `terraform plan` to review the resources being created
- If everything looks correct in the plan output, run `terraform apply -var-file ./tfvars/vars.tfvars`

``` hcl
data "terraform_remote_state" "day0" {
  backend = "s3"

  config = {
    bucket  = "ooc-us-gov-west-1-tf-state"
    region  = var.aws_region
    key     = "ooc-us-gov-west-1-tfsetup.tfstate"
    profile = "ooc-mgmt"
  }
}
```
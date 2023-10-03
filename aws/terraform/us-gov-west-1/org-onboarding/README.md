# Organization Onboarding

## Description
The organization onboarding module is responsible for joining the target AWS account to an organization.

FedRAMP Compliance: High

## Dependencies
- Account Initializaiton

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## tfvars Example
mgmt_role_arn    = "arn:aws-us-gov:iam::111111111111:role/tfadmin"
mgmt_external_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx"
org_role_arn     = "arn:aws-us-gov:iam::111111111111:role/tfadmin"
org_external_id  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx"

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
    bucket         = "pak-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "pak-us-gov-west-1-tfsetup.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```

## Deployment Steps
- Update the `mgmt_*` and `org_*` variables (role ARN and external ID) prior to running
- Change the working directory to the `management-account` directory
- If you are running this directory for the first time, comment out the S3 backend in `tstate.tf`
  - From in front of `backend "s3"` to the bracket associated with the end of the code block
- Run `terraform init`
- Run `terraform plan` to review the resources being created
- If everything looks correct in the plan output, run `terraform apply -var-file vars.tfvars`

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
    bucket         = "pak-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "pak-us-gov-west-1-tfsetup.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```
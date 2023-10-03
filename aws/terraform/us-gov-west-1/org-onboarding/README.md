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
1. Update the `mgmt_*` and `org_*` variables (role ARN and external ID) prior to running
2. Change the working directory the `org-onboarding` folder
   - If you are running this directory for the first time, comment out the S3 backend in `tstate.tf` from in front of `backend "s3"` to the bracket associated with the end of the code block
3. Run `terraform init` to download modules and create initial local state file.

4. Populate `vars.tfvars` 

5. Run `terraform plan -var-file vars.tfvars` to ensure no errors and validate plan is deploying expected resources.

6. Run `terraform apply -var-file vars.tfvars` to deploy infrastructure.


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
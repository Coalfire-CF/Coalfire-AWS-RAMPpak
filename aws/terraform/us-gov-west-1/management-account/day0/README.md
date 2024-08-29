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
    bucket         = "pak-<aws-region>-tf-state"
    region         = "<aws-region>"
    key            = "pak-<aws-region>-tfsetup.tfstate"
    dynamodb_table = "pak-<aws-region>-state-lock"
    encrypt        = true
  }
}
```

## tfvars Example
``` hcl
resource_prefix = "<customer-prefix>"
aws_region      = "<aws-region>"
```

## Deployment Steps
1. Change the working directory the `management-account/day0` folder
2. If you are running this directory for the first time, comment out the S3 backend in `tstate.tf`
   - From in front of `backend "s3"` to the bracket associated with the end of the code block
3. Run `terraform init` to download modules and create initial local state file.

4. Populate `vars.tfvars` 

5. Run `terraform plan -var-file vars.tfvars` to ensure no errors and validate plan is deploying expected resources.

6. Run `terraform apply -var-file vars.tfvars` to deploy infrastructure.

``` hcl
data "terraform_remote_state" "day0" {
  backend = "s3"

  config = {
    bucket  = "pak-<aws-region>-tf-state"
    region  = var.aws_region
    key     = "pak-<aws-region>-tfsetup.tfstate"
    profile = "pak-mgmt"
  }
}
```


# AWS Account Setup Terraform Module


## Description

The AWS account set up module creates the initial account configuration for your project, including IAM roles, KMS keys, S3 installs bucket, and more.

FedRAMP Compliance: High

## Resource List

Resources that are created as a part of this module include:

- IAM role, policies, and instance profiles for Packer to assume during AMI creation (Optional, one account can build and store AMIs and share them with other accounts)
- KMS keys and typically required IAM permissions for commonly used services (S3, DynamoDB, ELB, RDS, EBS, etc.)
- S3 buckets (ELB Access Logs bucket is optional, with multiple accounts, you can designate one as a centralized logging account and have other accounts send ELB logs to one account's bucket, this is not possible with S3 access logs where the bucket must be in the same account)
  - Set "create_s3_elb_accesslogs_bucket" to "true" if this is run in an account where you want the logs to be sent.
- Security core module resources (Optional, Terraform state resources don't have to be in every account)

## Assumptions
* `application_account_numbers` isn't required - you can feed it `application_account_numbers=[""]`

## Usage
"Management Core" account.  Terraform state is stored here, Packer AMIs are built here, is also Management Account for AWS Organizations:
```
module "account-setup" {
  source = "github.com/Coalfire-CF/terraform-aws-account-setup?ref=v0.0.20"

  aws_region         = "us-gov-west-1"
  default_aws_region = "us-gov-west-1"

  application_account_numbers = ["account-number1", "account-number2", "account-number3"]
  account_number              = "your-account-number"

  resource_prefix         = "pak"
  
  ### Cloudtrail ###
  create_cloudtrail                      = true
  is_organization                        = true
  organization_id                        = "your-organization-id"
  cloudwatch_log_group_retention_in_days = 30

  ### KMS ###
  additional_kms_keys = [
    {
      name   = "nfw"
      policy = "${data.aws_iam_policy_document.default_key_policy.json}"
    }
  ]

  ### Packer ###
  create_packer_iam = true # Packer AMIs will be built and kept on this account and shared with other accounts (share accounts is provided to Packer as a variable at build time)

  ### Terraform ###
  create_security_core = true # Terraform state will be kept on this account
}
```

Member account.  Does not need Terraform resources (S3 bucket to store state, DynamoDB table for state lock), Packer AMIs will not be built in this account, is not a Management account for AWS Organizations.
```
module "account-setup" {
  source = "github.com/Coalfire-CF/terraform-aws-account-setup?ref=v0.0.20"

  aws_region         = "us-gov-west-1"
  default_aws_region = "us-gov-west-1"

  application_account_numbers = ["account-number1", "account-number2", "account-number3"]
  account_number              = "your-account-number"

  resource_prefix         = "pak"

  ### KMS ###
  additional_kms_keys = [
    {
      name   = "nfw"
      policy = "${data.aws_iam_policy_document.default_key_policy.json}"
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_additional_kms_keys"></a> [additional\_kms\_keys](#module\_additional\_kms\_keys) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_backup_kms_key"></a> [backup\_kms\_key](#module\_backup\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_cloudwatch_kms_key"></a> [cloudwatch\_kms\_key](#module\_cloudwatch\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_config_kms_key"></a> [config\_kms\_key](#module\_config\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_dynamo_kms_key"></a> [dynamo\_kms\_key](#module\_dynamo\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_ebs_kms_key"></a> [ebs\_kms\_key](#module\_ebs\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_lambda_kms_key"></a> [lambda\_kms\_key](#module\_lambda\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_rds_kms_key"></a> [rds\_kms\_key](#module\_rds\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_s3-accesslogs"></a> [s3-accesslogs](#module\_s3-accesslogs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-backups"></a> [s3-backups](#module\_s3-backups) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-cloudtrail"></a> [s3-cloudtrail](#module\_s3-cloudtrail) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-config"></a> [s3-config](#module\_s3-config) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-elb-accesslogs"></a> [s3-elb-accesslogs](#module\_s3-elb-accesslogs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-fedrampdoc"></a> [s3-fedrampdoc](#module\_s3-fedrampdoc) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-installs"></a> [s3-installs](#module\_s3-installs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3_kms_key"></a> [s3\_kms\_key](#module\_s3\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_security-core"></a> [security-core](#module\_security-core) | github.com/Coalfire-CF/terraform-aws-securitycore | multi_account_fixes |
| <a name="module_sm_kms_key"></a> [sm\_kms\_key](#module\_sm\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_sns_kms_key"></a> [sns\_kms\_key](#module\_sns\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.all_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.packer_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.cloudtrail-to-cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.packer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.cloudtrail-to-cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.packer_access_attach_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.cloudtrail-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.packer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_grant.packer_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_grant.packer_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_s3_bucket_policy.cloudtrail_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.config_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.cloudtrail_assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamo_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elb_accesslogs_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_accesslogs_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_config_bucket_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secrets_manager_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_number"></a> [account\_number](#input\_account\_number) | The AWS account number resources are being deployed into | `string` | n/a | yes |
| <a name="input_additional_kms_keys"></a> [additional\_kms\_keys](#input\_additional\_kms\_keys) | a list of maps of any additional KMS keys that need to be created | `list(map(string))` | `[]` | no |
| <a name="input_application_account_numbers"></a> [application\_account\_numbers](#input\_application\_account\_numbers) | AWS account numbers for all application accounts that might need shared access to resources like KMS keys | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create resources in | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | The number of days to retain Cloudwatch logs | `number` | `30` | no |
| <a name="input_create_backup_kms_key"></a> [create\_backup\_kms\_key](#input\_create\_backup\_kms\_key) | create KMS key for AWS Backups | `bool` | `true` | no |
| <a name="input_create_cloudtrail"></a> [create\_cloudtrail](#input\_create\_cloudtrail) | Whether or not to create cloudtrail resources | `bool` | `false` | no |
| <a name="input_create_cloudwatch_kms_key"></a> [create\_cloudwatch\_kms\_key](#input\_create\_cloudwatch\_kms\_key) | create KMS key for AWS Cloudwatch | `bool` | `true` | no |
| <a name="input_create_config_kms_key"></a> [create\_config\_kms\_key](#input\_create\_config\_kms\_key) | create KMS key for AWS Cloudwatch | `bool` | `true` | no |
| <a name="input_create_dynamo_kms_key"></a> [create\_dynamo\_kms\_key](#input\_create\_dynamo\_kms\_key) | create KMS key for dynamodb | `bool` | `true` | no |
| <a name="input_create_ebs_kms_key"></a> [create\_ebs\_kms\_key](#input\_create\_ebs\_kms\_key) | create KMS key for ebs | `bool` | `true` | no |
| <a name="input_create_lambda_kms_key"></a> [create\_lambda\_kms\_key](#input\_create\_lambda\_kms\_key) | create KMS key for lambda | `bool` | `true` | no |
| <a name="input_create_packer_iam"></a> [create\_packer\_iam](#input\_create\_packer\_iam) | Whether or not to create Packer IAM resources | `bool` | `false` | no |
| <a name="input_create_rds_kms_key"></a> [create\_rds\_kms\_key](#input\_create\_rds\_kms\_key) | create KMS key for rds | `bool` | `true` | no |
| <a name="input_create_s3_accesslogs_bucket"></a> [create\_s3\_accesslogs\_bucket](#input\_create\_s3\_accesslogs\_bucket) | Create S3 Access Logs Bucket | `bool` | `true` | no |
| <a name="input_create_s3_backups_bucket"></a> [create\_s3\_backups\_bucket](#input\_create\_s3\_backups\_bucket) | Create S3 Backups Bucket | `bool` | `true` | no |
| <a name="input_create_s3_config_bucket"></a> [create\_s3\_config\_bucket](#input\_create\_s3\_config\_bucket) | Create S3 AWS Config Bucket for conformance pack storage | `bool` | `true` | no |
| <a name="input_create_s3_elb_accesslogs_bucket"></a> [create\_s3\_elb\_accesslogs\_bucket](#input\_create\_s3\_elb\_accesslogs\_bucket) | Create S3 ELB Access Logs Bucket | `bool` | `true` | no |
| <a name="input_create_s3_fedrampdoc_bucket"></a> [create\_s3\_fedrampdoc\_bucket](#input\_create\_s3\_fedrampdoc\_bucket) | Create S3 FedRAMP Documents Bucket | `bool` | `true` | no |
| <a name="input_create_s3_installs_bucket"></a> [create\_s3\_installs\_bucket](#input\_create\_s3\_installs\_bucket) | Create S3 Installs Bucket | `bool` | `true` | no |
| <a name="input_create_s3_kms_key"></a> [create\_s3\_kms\_key](#input\_create\_s3\_kms\_key) | create KMS key for S3 | `bool` | `true` | no |
| <a name="input_create_security_core"></a> [create\_security\_core](#input\_create\_security\_core) | Whether or not to create Security Core resources | `bool` | `false` | no |
| <a name="input_create_sm_kms_key"></a> [create\_sm\_kms\_key](#input\_create\_sm\_kms\_key) | create KMS key for secrets manager | `bool` | `true` | no |
| <a name="input_create_sns_kms_key"></a> [create\_sns\_kms\_key](#input\_create\_sns\_kms\_key) | create KMS key for SNS | `bool` | `true` | no |
| <a name="input_default_aws_region"></a> [default\_aws\_region](#input\_default\_aws\_region) | The default AWS region to create resources in | `string` | n/a | yes |
| <a name="input_is_organization"></a> [is\_organization](#input\_is\_organization) | Whether or not to enable certain settings for AWS Organization | `bool` | `true` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | AWS Organization ID | `string` | `null` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix for resources | `string` | n/a | yes |
| <a name="input_root_org_account_number"></a> [root\_org\_account\_number](#input\_root\_org\_account\_number) | The AWS account number for the Root Org Account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_kms_key_arns"></a> [additional\_kms\_key\_arns](#output\_additional\_kms\_key\_arns) | n/a |
| <a name="output_additional_kms_key_ids"></a> [additional\_kms\_key\_ids](#output\_additional\_kms\_key\_ids) | n/a |
| <a name="output_backup_kms_key_arn"></a> [backup\_kms\_key\_arn](#output\_backup\_kms\_key\_arn) | n/a |
| <a name="output_backup_kms_key_id"></a> [backup\_kms\_key\_id](#output\_backup\_kms\_key\_id) | n/a |
| <a name="output_cloudwatch_kms_key_arn"></a> [cloudwatch\_kms\_key\_arn](#output\_cloudwatch\_kms\_key\_arn) | n/a |
| <a name="output_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#output\_cloudwatch\_kms\_key\_id) | n/a |
| <a name="output_config_kms_key_arn"></a> [config\_kms\_key\_arn](#output\_config\_kms\_key\_arn) | n/a |
| <a name="output_config_kms_key_id"></a> [config\_kms\_key\_id](#output\_config\_kms\_key\_id) | n/a |
| <a name="output_dynamo_kms_key_arn"></a> [dynamo\_kms\_key\_arn](#output\_dynamo\_kms\_key\_arn) | n/a |
| <a name="output_dynamo_kms_key_id"></a> [dynamo\_kms\_key\_id](#output\_dynamo\_kms\_key\_id) | n/a |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | n/a |
| <a name="output_ebs_kms_key_arn"></a> [ebs\_kms\_key\_arn](#output\_ebs\_kms\_key\_arn) | n/a |
| <a name="output_ebs_kms_key_id"></a> [ebs\_kms\_key\_id](#output\_ebs\_kms\_key\_id) | n/a |
| <a name="output_lambda_kms_key_arn"></a> [lambda\_kms\_key\_arn](#output\_lambda\_kms\_key\_arn) | n/a |
| <a name="output_lambda_kms_key_id"></a> [lambda\_kms\_key\_id](#output\_lambda\_kms\_key\_id) | n/a |
| <a name="output_rds_kms_key_arn"></a> [rds\_kms\_key\_arn](#output\_rds\_kms\_key\_arn) | n/a |
| <a name="output_rds_kms_key_id"></a> [rds\_kms\_key\_id](#output\_rds\_kms\_key\_id) | n/a |
| <a name="output_s3_access_logs_arn"></a> [s3\_access\_logs\_arn](#output\_s3\_access\_logs\_arn) | n/a |
| <a name="output_s3_access_logs_id"></a> [s3\_access\_logs\_id](#output\_s3\_access\_logs\_id) | n/a |
| <a name="output_s3_backups_arn"></a> [s3\_backups\_arn](#output\_s3\_backups\_arn) | n/a |
| <a name="output_s3_backups_id"></a> [s3\_backups\_id](#output\_s3\_backups\_id) | n/a |
| <a name="output_s3_cloudtrail_arn"></a> [s3\_cloudtrail\_arn](#output\_s3\_cloudtrail\_arn) | n/a |
| <a name="output_s3_cloudtrail_id"></a> [s3\_cloudtrail\_id](#output\_s3\_cloudtrail\_id) | n/a |
| <a name="output_s3_config_arn"></a> [s3\_config\_arn](#output\_s3\_config\_arn) | n/a |
| <a name="output_s3_config_id"></a> [s3\_config\_id](#output\_s3\_config\_id) | n/a |
| <a name="output_s3_elb_access_logs_arn"></a> [s3\_elb\_access\_logs\_arn](#output\_s3\_elb\_access\_logs\_arn) | n/a |
| <a name="output_s3_elb_access_logs_id"></a> [s3\_elb\_access\_logs\_id](#output\_s3\_elb\_access\_logs\_id) | n/a |
| <a name="output_s3_fedrampdoc_arn"></a> [s3\_fedrampdoc\_arn](#output\_s3\_fedrampdoc\_arn) | n/a |
| <a name="output_s3_fedrampdoc_id"></a> [s3\_fedrampdoc\_id](#output\_s3\_fedrampdoc\_id) | n/a |
| <a name="output_s3_installs_arn"></a> [s3\_installs\_arn](#output\_s3\_installs\_arn) | n/a |
| <a name="output_s3_installs_id"></a> [s3\_installs\_id](#output\_s3\_installs\_id) | n/a |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | n/a |
| <a name="output_s3_kms_key_id"></a> [s3\_kms\_key\_id](#output\_s3\_kms\_key\_id) | n/a |
| <a name="output_s3_tstate_bucket_name"></a> [s3\_tstate\_bucket\_name](#output\_s3\_tstate\_bucket\_name) | n/a |
| <a name="output_sm_kms_key_arn"></a> [sm\_kms\_key\_arn](#output\_sm\_kms\_key\_arn) | n/a |
| <a name="output_sm_kms_key_id"></a> [sm\_kms\_key\_id](#output\_sm\_kms\_key\_id) | n/a |
| <a name="output_sns_kms_key_arn"></a> [sns\_kms\_key\_arn](#output\_sns\_kms\_key\_arn) | n/a |
| <a name="output_sns_kms_key_id"></a> [sns\_kms\_key\_id](#output\_sns\_kms\_key\_id) | n/a |
<!-- END_TF_DOCS -->

## Contributing

If you're interested in contributing to our projects, please review the [Contributing Guidelines](CONTRIBUTING.md). And send an email to [our team](contributing@coalfire.com) to receive a copy of our CLA and start the onboarding process.

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_additional_kms_keys"></a> [additional\_kms\_keys](#module\_additional\_kms\_keys) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_backup_kms_key"></a> [backup\_kms\_key](#module\_backup\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_cloudwatch_kms_key"></a> [cloudwatch\_kms\_key](#module\_cloudwatch\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_dynamo_kms_key"></a> [dynamo\_kms\_key](#module\_dynamo\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_ebs_kms_key"></a> [ebs\_kms\_key](#module\_ebs\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_lambda_kms_key"></a> [lambda\_kms\_key](#module\_lambda\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_rds_kms_key"></a> [rds\_kms\_key](#module\_rds\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_s3-accesslogs"></a> [s3-accesslogs](#module\_s3-accesslogs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-backups"></a> [s3-backups](#module\_s3-backups) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-cloudtrail"></a> [s3-cloudtrail](#module\_s3-cloudtrail) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-elb-accesslogs"></a> [s3-elb-accesslogs](#module\_s3-elb-accesslogs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-fedrampdoc"></a> [s3-fedrampdoc](#module\_s3-fedrampdoc) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3-installs"></a> [s3-installs](#module\_s3-installs) | github.com/Coalfire-CF/terraform-aws-s3 | v1.0.1 |
| <a name="module_s3_kms_key"></a> [s3\_kms\_key](#module\_s3\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_security-core"></a> [security-core](#module\_security-core) | github.com/Coalfire-CF/terraform-aws-securitycore | 02087ae72394cd06431efc5dbbc4bf1f7f88ad14 |
| <a name="module_sm_kms_key"></a> [sm\_kms\_key](#module\_sm\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |
| <a name="module_sns_kms_key"></a> [sns\_kms\_key](#module\_sns\_kms\_key) | github.com/Coalfire-CF/terraform-aws-kms | v0.0.6 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.all_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.packer_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.cloudtrail-to-cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.packer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.cloudtrail-to-cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.packer_access_attach_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.cloudtrail-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.packer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_grant.packer_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_grant.packer_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_s3_bucket_policy.cloudtrail_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.cloudtrail_assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamo_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elb_accesslogs_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_accesslogs_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secrets_manager_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_number"></a> [account\_number](#input\_account\_number) | The AWS account number resources are being deployed into | `string` | n/a | yes |
| <a name="input_additional_kms_keys"></a> [additional\_kms\_keys](#input\_additional\_kms\_keys) | a list of maps of any additional KMS keys that need to be created | `list(map(string))` | `[]` | no |
| <a name="input_application_account_numbers"></a> [application\_account\_numbers](#input\_application\_account\_numbers) | AWS account numbers for all application accounts that might need shared access to resources like KMS keys | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create resources in | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | The number of days to retain Cloudwatch logs | `number` | `30` | no |
| <a name="input_create_backup_kms_key"></a> [create\_backup\_kms\_key](#input\_create\_backup\_kms\_key) | create KMS key for AWS Backups | `bool` | `true` | no |
| <a name="input_create_cloudtrail"></a> [create\_cloudtrail](#input\_create\_cloudtrail) | Whether or not to create cloudtrail resources | `bool` | `false` | no |
| <a name="input_create_cloudwatch_kms_key"></a> [create\_cloudwatch\_kms\_key](#input\_create\_cloudwatch\_kms\_key) | create KMS key for AWS Cloudwatch | `bool` | `true` | no |
| <a name="input_create_dynamo_kms_key"></a> [create\_dynamo\_kms\_key](#input\_create\_dynamo\_kms\_key) | create KMS key for dynamodb | `bool` | `true` | no |
| <a name="input_create_ebs_kms_key"></a> [create\_ebs\_kms\_key](#input\_create\_ebs\_kms\_key) | create KMS key for ebs | `bool` | `true` | no |
| <a name="input_create_lambda_kms_key"></a> [create\_lambda\_kms\_key](#input\_create\_lambda\_kms\_key) | create KMS key for lambda | `bool` | `true` | no |
| <a name="input_create_packer_iam"></a> [create\_packer\_iam](#input\_create\_packer\_iam) | Whether or not to create Packer IAM resources | `bool` | `false` | no |
| <a name="input_create_rds_kms_key"></a> [create\_rds\_kms\_key](#input\_create\_rds\_kms\_key) | create KMS key for rds | `bool` | `true` | no |
| <a name="input_create_s3_accesslogs_bucket"></a> [create\_s3\_accesslogs\_bucket](#input\_create\_s3\_accesslogs\_bucket) | Create S3 Access Logs Bucket | `bool` | `false` | no |
| <a name="input_create_s3_backups_bucket"></a> [create\_s3\_backups\_bucket](#input\_create\_s3\_backups\_bucket) | Create S3 Backups Bucket | `bool` | `true` | no |
| <a name="input_create_s3_elb_accesslogs_bucket"></a> [create\_s3\_elb\_accesslogs\_bucket](#input\_create\_s3\_elb\_accesslogs\_bucket) | Create S3 ELB Access Logs Bucket | `bool` | `false` | no |
| <a name="input_create_s3_fedrampdoc_bucket"></a> [create\_s3\_fedrampdoc\_bucket](#input\_create\_s3\_fedrampdoc\_bucket) | Create S3 FedRAMP Documents Bucket | `bool` | `true` | no |
| <a name="input_create_s3_installs_bucket"></a> [create\_s3\_installs\_bucket](#input\_create\_s3\_installs\_bucket) | Create S3 Installs Bucket | `bool` | `true` | no |
| <a name="input_create_s3_kms_key"></a> [create\_s3\_kms\_key](#input\_create\_s3\_kms\_key) | create KMS key for S3 | `bool` | `true` | no |
| <a name="input_create_security_core"></a> [create\_security\_core](#input\_create\_security\_core) | Whether or not to create Security Core resources | `bool` | `false` | no |
| <a name="input_create_sm_kms_key"></a> [create\_sm\_kms\_key](#input\_create\_sm\_kms\_key) | create KMS key for secrets manager | `bool` | `true` | no |
| <a name="input_create_sns_kms_key"></a> [create\_sns\_kms\_key](#input\_create\_sns\_kms\_key) | create KMS key for SNS | `bool` | `true` | no |
| <a name="input_default_aws_region"></a> [default\_aws\_region](#input\_default\_aws\_region) | The default AWS region to create resources in | `string` | n/a | yes |
| <a name="input_is_organization"></a> [is\_organization](#input\_is\_organization) | Whether or not to enable certain settings for AWS Organization | `bool` | `true` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | AWS Organization ID | `string` | `null` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix for resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_kms_key_arns"></a> [additional\_kms\_key\_arns](#output\_additional\_kms\_key\_arns) | n/a |
| <a name="output_additional_kms_key_ids"></a> [additional\_kms\_key\_ids](#output\_additional\_kms\_key\_ids) | n/a |
| <a name="output_backup_kms_key_arn"></a> [backup\_kms\_key\_arn](#output\_backup\_kms\_key\_arn) | n/a |
| <a name="output_backup_kms_key_id"></a> [backup\_kms\_key\_id](#output\_backup\_kms\_key\_id) | n/a |
| <a name="output_cloudtrail_sns_kms_key_arn"></a> [cloudtrail\_sns\_kms\_key\_arn](#output\_cloudtrail\_sns\_kms\_key\_arn) | n/a |
| <a name="output_cloudtrail_sns_kms_key_id"></a> [cloudtrail\_sns\_kms\_key\_id](#output\_cloudtrail\_sns\_kms\_key\_id) | n/a |
| <a name="output_cloudwatch_kms_key_arn"></a> [cloudwatch\_kms\_key\_arn](#output\_cloudwatch\_kms\_key\_arn) | n/a |
| <a name="output_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#output\_cloudwatch\_kms\_key\_id) | n/a |
| <a name="output_dynamo_kms_key_arn"></a> [dynamo\_kms\_key\_arn](#output\_dynamo\_kms\_key\_arn) | n/a |
| <a name="output_dynamo_kms_key_id"></a> [dynamo\_kms\_key\_id](#output\_dynamo\_kms\_key\_id) | n/a |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | n/a |
| <a name="output_ebs_kms_key_arn"></a> [ebs\_kms\_key\_arn](#output\_ebs\_kms\_key\_arn) | n/a |
| <a name="output_ebs_kms_key_id"></a> [ebs\_kms\_key\_id](#output\_ebs\_kms\_key\_id) | n/a |
| <a name="output_lambda_kms_key_arn"></a> [lambda\_kms\_key\_arn](#output\_lambda\_kms\_key\_arn) | n/a |
| <a name="output_lambda_kms_key_id"></a> [lambda\_kms\_key\_id](#output\_lambda\_kms\_key\_id) | n/a |
| <a name="output_rds_kms_key_arn"></a> [rds\_kms\_key\_arn](#output\_rds\_kms\_key\_arn) | n/a |
| <a name="output_rds_kms_key_id"></a> [rds\_kms\_key\_id](#output\_rds\_kms\_key\_id) | n/a |
| <a name="output_s3_access_logs_arn"></a> [s3\_access\_logs\_arn](#output\_s3\_access\_logs\_arn) | n/a |
| <a name="output_s3_access_logs_id"></a> [s3\_access\_logs\_id](#output\_s3\_access\_logs\_id) | n/a |
| <a name="output_s3_backups_arn"></a> [s3\_backups\_arn](#output\_s3\_backups\_arn) | n/a |
| <a name="output_s3_backups_id"></a> [s3\_backups\_id](#output\_s3\_backups\_id) | n/a |
| <a name="output_s3_cloudtrail_arn"></a> [s3\_cloudtrail\_arn](#output\_s3\_cloudtrail\_arn) | n/a |
| <a name="output_s3_cloudtrail_id"></a> [s3\_cloudtrail\_id](#output\_s3\_cloudtrail\_id) | n/a |
| <a name="output_s3_elb_access_logs_arn"></a> [s3\_elb\_access\_logs\_arn](#output\_s3\_elb\_access\_logs\_arn) | n/a |
| <a name="output_s3_elb_access_logs_id"></a> [s3\_elb\_access\_logs\_id](#output\_s3\_elb\_access\_logs\_id) | n/a |
| <a name="output_s3_fedrampdoc_arn"></a> [s3\_fedrampdoc\_arn](#output\_s3\_fedrampdoc\_arn) | n/a |
| <a name="output_s3_fedrampdoc_id"></a> [s3\_fedrampdoc\_id](#output\_s3\_fedrampdoc\_id) | n/a |
| <a name="output_s3_installs_arn"></a> [s3\_installs\_arn](#output\_s3\_installs\_arn) | n/a |
| <a name="output_s3_installs_id"></a> [s3\_installs\_id](#output\_s3\_installs\_id) | n/a |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | n/a |
| <a name="output_s3_kms_key_id"></a> [s3\_kms\_key\_id](#output\_s3\_kms\_key\_id) | n/a |
| <a name="output_s3_tstate_bucket_name"></a> [s3\_tstate\_bucket\_name](#output\_s3\_tstate\_bucket\_name) | n/a |
| <a name="output_sm_kms_key_arn"></a> [sm\_kms\_key\_arn](#output\_sm\_kms\_key\_arn) | n/a |
| <a name="output_sm_kms_key_id"></a> [sm\_kms\_key\_id](#output\_sm\_kms\_key\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

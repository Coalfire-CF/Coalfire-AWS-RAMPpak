## DAY 0 Deployment 
<div align="center">
<img src="coalfire_logo.png" width="200">

</div>

# AWS Account Setup Terraform Module


## Description

The AWS account set up module creates the initial account configuration for your project, including IAM roles, KMS keys, S3 installs bucket, and more.

FedRAMP Compliance: High

## Resource List

Resources that are created as a part of this module include:

- IAM roles
- IAM policies
- IAM instance profiles
- KMS keys
- S3 buckets
- Security core module resources

## Usage
```
module "account-setup" {
  source = "github.com/Coalfire-CF/terraform-aws-account-setup"

  aws_region = "us-east-1"
  default_aws_region = "us-east-1"

  application_account_numbers = ["account-number1", "account-number2", "account-number3"]
  account_number = "your-account-number"

  resource_prefix = "pre"
  create_cloudtrail = true
  partition = "aws"
  ad_secrets_manager_path = "your/ad/path"
  enable_aws_config = true
  delete_after = 90
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements


## Providers


## Modules


## Resources

## Inputs

## Outputs

<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
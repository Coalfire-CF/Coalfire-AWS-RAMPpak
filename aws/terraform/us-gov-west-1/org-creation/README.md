# Organization Creation

## Description
This module facilitates the creation of organization infrastrucutre in AWS. Organizational structures are established and AWS security services such as AWS Security Hub, AWS Config and Multi-Account Setup, and AWS GuardDuty are integrated. Corresponding organization policies are also created.

FedRAMP Compliance: High

## Dependencies
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Code Updates
```hcl
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
    key            = "pak-us-gov-west-1-org.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```

## Deployment Steps
1. Change the working directory the `org-creation` folder
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
    bucket  = "${var.resource_prefix}-${var.default_aws_region}-tf-state"
    region  = var.default_aws_region
    key     = "${var.resource_prefix}-${var.default_aws_region}-tfsetup.tfstate"
    profile = "pak-mgmt"
  }
}
```

## tfvars Example
``` hcl
resource_prefix = "<customer-prefix>"
aws_region = "<aws-region>"
service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com"]
enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
feature_set = "ALL"
org_member_account_numbers = ["1111111111111"]
delegated_admin_account_id = "1111111111111"
```

## Module Example
``` hcl
module "org" {
  source = "github.com/Coalfire-CF/terraform-aws-organization"

  providers = {
    aws = aws.mgmt
  }

  feature_set = "ALL"
  aws_region                = var.aws_region
  aws_sec_hub_standards_arn = ["arn:${data.aws_partition.current.partition}:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0", "arn:${data.aws_partition.current.partition}:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"]
  resource_prefix           = var.resource_prefix
  s3_kms_key_arn            = data.terraform_remote_state.day0.outputs.s3_kms_key_arn
  org_member_account_numbers = var.org_member_account_numbers
  delegated_admin_account_id = var.delegated_admin_account_id
  delegated_service_principal = var.delegated_service_principal
  enabled_policy_types = var.enabled_policy_types
  service_access_principals = var.service_access_principals
}


resource "aws_organizations_organizational_unit" "ou" {
  depends_on = [module.org]
  name      = "app_ou"
  parent_id = module.org.org_roots[0]["id"]
}


resource "aws_organizations_resource_policy" "org_resource_policy" {
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${module.org.master_account_id}"
      },
      "Action": [
        "organizations:CreatePolicy",
        "organizations:UpdatePolicy",
        "organizations:DeletePolicy",
        "organizations:AttachPolicy",
        "organizations:DetachPolicy",
        "organizations:EnablePolicyType",
        "organizations:DisablePolicyType",
        "organizations:DescribeOrganization",
        "organizations:DescribeOrganizationalUnit",
        "organizations:DescribeAccount",
        "organizations:DescribePolicy",
        "organizations:DescribeEffectivePolicy",
        "organizations:ListRoots",
        "organizations:ListOrganizationalUnitsForParent",
        "organizations:ListParents",
        "organizations:ListChildren",
        "organizations:ListAccounts",
        "organizations:ListAccountsForParent",
        "organizations:ListPolicies",
        "organizations:ListPoliciesForTarget",
        "organizations:ListTargetsForPolicy",
        "organizations:ListTagsForResource"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
```
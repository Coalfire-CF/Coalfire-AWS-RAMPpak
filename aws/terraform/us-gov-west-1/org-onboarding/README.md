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
    bucket         = "ooc-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "ooc-us-gov-west-1-org-onboard.tfstate"
    dynamodb_table = "ooc-us-gov-west-1-state-lock"
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
- If everything looks correct in the plan output, run `terraform apply -var-file ./tfvars/vars.tfvars`

``` sh
#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

ACCOUNT_ID=$1
BU_ROLE_ARN=$2
BU_EXTERNAL_ID=$3
ORG_ROLE_ARN=$4
ORG_EXTERNAL_ID=$5

# Assume into org root account
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn $ORG_ROLE_ARN \
--external-id $ORG_EXTERNAL_ID \
--role-session-name interlock_session \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))

HANDSHAKE=$(aws organizations invite-account-to-organization \
--target '{"Type": "ACCOUNT", "Id": "'$ACCOUNT_ID'"}' \
--notes "This is a request for this account to join the Federal Ops Stack organization." \
--output text \
--query "Handshake.Id")

# Remove assume role
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

# Assume into BU account
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn $BU_ROLE_ARN \
--external-id $BU_EXTERNAL_ID \
--role-session-name interlock_session \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))

# Accept handshake in BU account
aws organizations accept-handshake --handshake-id $HANDSHAKE
```
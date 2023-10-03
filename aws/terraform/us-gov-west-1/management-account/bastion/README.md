# Bastion

Deploy a windows server in boundary to access the management and application infrastructure.

## Dependencies

- AWS CLI is installed
- day0 directory deployed
- networking directory deployed
- org-creation directory deployed
- org-onboarding direcotry deployed

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
    key            = "${var.location_abbreviation}-bastion.tfstate"
    dynamodb_table = "ooc-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```
Update the `remote-data.tf` to pull appropriate remote-data from storage

``` hcl
data "terraform_remote_state" "day0" {
  backend = "s3"

  config = {
    bucket  = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region  = var.aws_region
    key     = "${var.resource_prefix}-${var.aws_region}-tfsetup.tfstate"
    profile = "ooc-mgmt"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket  = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region  = var.aws_region
    key     = "${var.resource_prefix}-${var.aws_region}-networking.tfstate"
    profile = "ooc-mgmt"
  }
}
```
## tfvars Example
``` hcl
resource_prefix = "ooc"
aws_region = "us-gov-west-1"
instance_name = "win_bastion"
instance_size = "t3a.medium"
key_name = "ooc-test"
instance_volume_size = 80
associate_eip = true
```


## Deployment Steps

1. Change directory to the `bastion` folder

2. Run `terraform init` to download modules and create initial local state file.

3. Populate `vars.tfvars` 

4. Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

5. Run `terraform apply` to deploy infrastructure.

## Next Steps

None
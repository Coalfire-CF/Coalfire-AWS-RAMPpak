# Networking Deployment Management Account 

## Description
This module includes the networking setup, including VPC provisions, Subnet creation and provisions, AWS network firewall resources and policies, and other various network components.

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
- NAT Gateways
- Internet Gateways
- AWS Network Firewall
- AWS Network Firewall Policies
- Cloudwatch Logs
- VPC Flow Logs
- IAM Roles
- IAM Policies
- KMS Keys

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
    key            = "pak-us-gov-west-1-networking.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
```

## tfvars Example
``` hcl
resource_prefix = "<customer-prefix>"
deploy_aws_nfw = true
aws_region = "<aws-region>"
cidrs_for_remote_access = ["<Customer-IP>"]
mgmt_vpc_cidr = "<Customer-Custom-CIDR-Range"
profile = "<customer-prefix>-mgmt"
```
## Assumptions

* Networking resources, including VPCs, Transit Gateways and Network Firewalls, are designed to be deployed under a single state.
* Outputs of this module can be referenced via terraform state in the following manner:
  * `module.mgmt_vpc.private_subnets["mvp-mgmt-compute-us-gov-west-1a"]`
  * `data.terraform_remote_state.network.outputs.public_subnets["mvp-mgmt-dmz-us-gov-west-1a"]`
* This is designed to automatically reference the firewall subnets when opted to be created.
* Automatically adds AWS region to the subnet name upon creation


## Deployment Steps
1. Change the working directory the `networking` folder
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
    bucket  = "pak-us-gov-west-1-tf-state"
    region  = var.aws_region
    key     = "pak-us-gov-west-1-tfsetup.tfstate"
    profile = "pak-mgmt"
  }
}
```

## Example Deployments
The below are example deployments of the networking module, it consists of 2 examples, one with AWS Network Firewall and one without.

### AWS Networking deployment with AWS Network Firewall
```hcl
module "mgmt_vpc" {
  source = "github.com/Coalfire-CF/terraform-aws-vpc-nfw"
  providers = {
    aws = aws.mgmt
  }

  name = "${var.resource_prefix}-mgmt"

  delete_protection = var.delete_protection

  cidr = var.mgmt_vpc_cidr

  azs = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]

  private_subnets = local.private_subnets

  private_subnet_name_tag = {
    "0" = "Compute"
    "1" = "Compute"
    "2" = "Compute"
    "3" = "Private"
    "4" = "Private"
    "5" = "Private"
  }

  public_subnets       = local.public_subnets
  public_subnet_suffix = "public"

  single_nat_gateway     = false
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  flow_log_destination_type              = "cloud-watch-logs"
  cloudwatch_log_group_retention_in_days = 30
  cloudwatch_log_group_kms_key_id        = data.terraform_remote_state.day0.outputs.cloudwatch_kms_key_arn

  ### Network Firewall ###
  deploy_aws_nfw                        = var.deploy_aws_nfw
  aws_nfw_prefix                        = var.resource_prefix
  aws_nfw_name                          = "pak-nfw"
  aws_nfw_stateless_rule_group          = local.stateless_rule_group_shrd_svcs
  aws_nfw_fivetuple_stateful_rule_group = local.fivetuple_rule_group_shrd_svcs
  aws_nfw_domain_stateful_rule_group    = local.domain_stateful_rule_group_shrd_svcs
  aws_nfw_suricata_stateful_rule_group  = local.suricata_rule_group_shrd_svcs
  nfw_kms_key_id                        = module.nfw_kms_key.kms_key_arn

  #When deploying NFW, firewall_subnets must be specified
  firewall_subnets       = local.firewall_subnets
  firewall_subnet_suffix = "firewall"

  /* Add Additional tags here */
  tags = {
    Owner       = var.resource_prefix
    Environment = "mgmt"
    createdBy   = "terraform"
  }
}
```

### AWS Networking deployment without AWS Network Firewall
```hcl
module "mgmt_vpc" {
  source = "github.com/Coalfire-CF/terraform-aws-vpc-nfw"
  providers = {
    aws = aws.mgmt
  }

  name = "${var.resource_prefix}-mgmt"

  delete_protection = var.delete_protection

  cidr = var.mgmt_vpc_cidr

  azs = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]

  private_subnets = local.private_subnets

  private_subnet_name_tag = {
    "0" = "Compute"
    "1" = "Compute"
    "2" = "Compute"
    "3" = "Private"
    "4" = "Private"
    "5" = "Private"
  }

  public_subnets       = local.public_subnets
  public_subnet_suffix = "public"

  single_nat_gateway     = false
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  flow_log_destination_type              = "cloud-watch-logs"
  cloudwatch_log_group_retention_in_days = 30
  cloudwatch_log_group_kms_key_id        = data.terraform_remote_state.day0.outputs.cloudwatch_kms_key_arn

  ### Network Firewall ###
  deploy_aws_nfw                        = var.deploy_aws_nfw
  aws_nfw_prefix                        = var.resource_prefix
  aws_nfw_name                          = "pak-nfw"
  aws_nfw_stateless_rule_group          = local.stateless_rule_group_shrd_svcs
  aws_nfw_fivetuple_stateful_rule_group = local.fivetuple_rule_group_shrd_svcs
  aws_nfw_domain_stateful_rule_group    = local.domain_stateful_rule_group_shrd_svcs
  aws_nfw_suricata_stateful_rule_group  = local.suricata_rule_group_shrd_svcs
  nfw_kms_key_id                        = module.nfw_kms_key.kms_key_arn

  #When deploying NFW, firewall_subnets must be specified
  firewall_subnets       = local.firewall_subnets
  firewall_subnet_suffix = "firewall"

  /* Add Additional tags here */
  tags = {
    Owner       = var.resource_prefix
    Environment = "mgmt"
    createdBy   = "terraform"
  }
}
```

#### Suricata rule example
Dropping cnn.com/HTTPS(TLS) and google.com/HTTP
```
drop tls any any -> $EXTERNAL_NET any (tls.sni; content: ".cnn.com"; startswith; nocase; endswith; msg: "matching TLS denylisted FQDNs"; priority: 1; flow:to_server, established; sid: 1; rev:1;)
drop http any any -> $EXTERNAL_NET any (http.host; content: ".google.com"; startswith; endswith; msg: "matching HTTP denylisted FQDNs"; priority: 1; flow: to_server, established; sid: 3; rev: 1;)
```






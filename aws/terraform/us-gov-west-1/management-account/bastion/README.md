# Bastion

Deploy a Windows server in boundary to access the management and application infrastructure.

## Dependencies

- AWS CLI is installed
- day0 directory deployed
- networking directory deployed
- org-creation directory deployed
- org-onboarding direcotry deployed

## Resource List
- EC2 Instance
- Elastic IP
- Network interface attachment
- IAM role
- IAM instance profile
- KMS RBAC grant
- AWS Security Group


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
    key            = "${var.resource_prefix}-${var.aws_region}-bastion.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
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
    profile = "pak-mgmt"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket  = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region  = var.aws_region
    key     = "${var.resource_prefix}-${var.aws_region}-networking.tfstate"
    profile = "pak-mgmt"
  }
}
```
## tfvars Example
``` hcl
resource_prefix = "pak"
aws_region = "us-gov-west-1"
instance_name = "win_bastion"
instance_size = "t3a.medium"
key_name = "pak"
instance_volume_size = 80
associate_eip = true
```

## Deployment Steps

1. Change directory to the `bastion` folder
2. If you are running this directory for the first time, comment out the S3 backend in `tstate.tf`
  - From in front of `backend "s3"` to the bracket associated with the end of the code block
3. Run `terraform init` to download modules and create initial local state file.

4. Populate `vars.tfvars` 

5. Run `terraform plan -var-file vars.tfvars` to ensure no errors and validate plan is deploying expected resources.

6. Run `terraform apply -var-file vars.tfvars` to deploy infrastructure.

## Example Deployment

```hcl
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["077303321853"]
  provider    = aws.mgmt

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-STIG-Full-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "win_bastion" {
  source = "github.com/Coalfire-CF/terraform-aws-ec2"

  name = var.instance_name

  ami               = data.aws_ami.ami.id
  ec2_instance_type = var.instance_size
  instance_count    = var.instance_count
  associate_eip     = var.associate_eip

  vpc_id          = data.terraform_remote_state.networking.outputs.mgmt_vpc_id
  subnet_ids      = [ data.terraform_remote_state.networking.outputs.public_subnets["pak-mgmt-public-us-gov-west-1a"]]
  ec2_key_pair    = var.key_name
  ebs_kms_key_arn = data.terraform_remote_state.day0.outputs.ebs_kms_key_arn

  # Storage
  root_volume_size = var.instance_volume_size

  # Security Group Rules
  ingress_rules = [
    {
      protocol    = "tcp"
      from_port   = "3389"
      to_port     = "3389"
      cidr_blocks = [data.terraform_remote_state.networking.outputs.mgmt_vpc_cidr] #add your public IP to allow for external access as well
  }
  ]

  egress_rules = [{
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  # Tagging
  global_tags = {}

}
```
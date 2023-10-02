data "amazon-ami" "al2" {
  filters = {
    name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"] # "602401143452" for commercial, "013241004608" for GovCloud
  region      = var.aws_region
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
}
data "amazon-ami" "al2-ecs" {
  filters = {
    name                = "amzn2-ami-ecs-kernel-5.10-hvm-*-x86_64-ebs"
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"] # "602401143452" for commercial, "013241004608" for GovCloud
  region      = var.aws_region
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
}

data "amazon-ami" "rhel8" {
  filters = {
    name                = "RHEL-8.*_HVM-????????-x86_64-*-Hourly*-GP2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["309956199498", "219670896067"] #309956199498 for commercial, 219670896067 for GovCloud.
  region      = var.aws_region
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
}

# Note: Must subscribe to https://aws.amazon.com/marketplace/pp?sku=7btbv7tkj4yxnrzltyygo1ipn to use this AMI
# The subscription must happen on mgmt account to build it, then on prod account to use it
data "amazon-ami" "ubuntu2004" {
  filters = {
    name                = "ubuntu-pro-fips-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-fips-server-*"
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["aws-marketplace"]
  region      = var.aws_region
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
}

data "amazon-ami" "ubuntu2204" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
    state               = "available"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon","513442679011"] # amazon = Commercial, 513442679011 = GovCloud
  region      = var.aws_region
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
}

source "amazon-ebs" "linux" {
  aws_polling {
    # Default value is 40, increasing to avoid timeout during encryption
    # https://developer.hashicorp.com/packer/plugins/builders/amazon#resourcenotready-error
    delay_seconds = 60
    max_attempts  = 240
  }
  ami_users                   = ["${var.app_account_id1}", "${var.app_account_id2}"]
  associate_public_ip_address = true
  ebs_optimized               = true
  encrypt_boot                = true
  iam_instance_profile        = "packer_profile"
  instance_type               = var.linux_build_instance_type
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sdb"
    volume_size           = 50
    volume_type           = "gp3"
  }
  kms_key_id = var.ebs_kms_key_id
  region     = var.aws_region
  subnet_id  = var.subnet_id
  vpc_id     = var.vpc_id
  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
    session_name = "packer_session"
  }
  ssh_keypair_name     = var.ssh_keypair_name
  ssh_private_key_file = var.ssh_private_key_file
}
### Global variables used by all Packer builds ###
variable "aws_region" {
  description = "The AWS region to build the AMI in."
  type        = string
}
variable "builder_account_id" {
  description = "The Management Account ID."
  type        = string
}
variable "partition" {
  description = "AWS account partition.  'aws' for commercial, 'aws-us-gov' for govcloud."
  type        = string
  default     = "aws"

  validation {
    condition     = can(regex("^(aws|aws-us-gov)$", var.partition))
    error_message = "ERROR: partition value must match 'aws' or 'aws-us-gov'."
  }
}

variable "app_account_id1" {
  description = "The app 1 Account ID."
  type        = string
}

variable "app_account_id2" {
  description = "The app 2 Account ID."
  type        = string
}

variable "ebs_kms_key_id" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

### Windows variables ###
variable "win_base_ami_name" {
  type    = string
  default = "Windows_Server-2019-English-Full-Base*"
}
variable "win_build_instance_type" {
  type    = string
  default = "c5a.2xlarge"
}

### Linux variables ###
variable "linux_build_instance_type" {
  type    = string
  default = "c5a.2xlarge"
}

### EKS Variables ###
variable "cni_plugin_version" {
  description = "Check latest CNI plugin version from https://github.com/containernetworking/plugins/releases"
  type    = string
  default = "v1.3.0"
}
variable "eks_build_date" {
  description = "Get build dates from https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html"
  type        = string
  default     = "2023-04-19"
}
variable "eks_major_version" {
  type    = string
  default = "1.27"
}
variable "eks_version" {
  description = "Get build dates from https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html"
  type        = string
  default     = "1.27.1"
}
variable "http_proxy" {
  type    = string
  default = ""
}
variable "https_proxy" {
  type    = string
  default = ""
}
variable "no_proxy" {
  type    = string
  default = ""
}
variable "source_ami_arch" {
  type    = string
  default = "x86_64"
}

### For Debugging ###
variable "ssh_keypair_name" {
  type    = string
  default = null
}

variable "ssh_private_key_file" {
  type    = string
  default = null
}

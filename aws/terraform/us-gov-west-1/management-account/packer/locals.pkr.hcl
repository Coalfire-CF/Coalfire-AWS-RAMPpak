locals {
  # These are default values that are not expected to change frequently
  datetime = formatdate("YYYY-MM-DD-hh-mm-ssZ", timestamp())

  # Linux
  aws_ssh_username = "ec2-user"

  # Shared
  ansible_role_path      = "../../../../../ansible/roles/"
  partition_disk_ansible = "./scripts/shared/partition-disk.yml"
  playbook_dir           = "./scripts/shared/playbook_dir"

  ### EKS ###
  # Common
  binary_bucket_name   = "amazon-eks"
  binary_bucket_region = "us-gov-west-1"

  # Ubuntu Variables
  pause_container_version = "3.5"
  pull_cni_from_github    = "true"
  cache_container_images  = "false"

  is_gov = var.partition == "aws-us-gov" ? true : false

}
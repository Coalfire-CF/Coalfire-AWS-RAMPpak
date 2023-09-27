data "aws_caller_identity" "mgmt_account" {
  # Get the management account ID
  provider = aws.mgmt
}

data "aws_partition" "current" {}


# data "aws_caller_identity" "app1_account" {
#   # Get the app1 account ID
#   provider = aws.app1
# }

# data "aws_caller_identity" "app2_account" {
#   # Get the app2 account ID
#   provider = aws.app2
# }


locals {
}

variable "resource_prefix" {
  type        = string
  default     = "ooc"
  description = "A prefix that should be attached to the names of resources"
}

variable "default_aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-gov-west-1"
}

variable "global_tags" {
  type = map(string)
  default = {
    managed_by    = "terraform"
    backup_policy = "aws-backup-minimum-compliance"
  }
  description = "Tags to apply globally to all appropriate AWS resources (that have tagging functionality)"
}
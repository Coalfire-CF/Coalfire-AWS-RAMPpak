data "aws_caller_identity" "mgmt_account" {
  # Get the management account ID
  provider = aws.mgmt
}

variable "resource_prefix" {
  type        = string
  default     = "pak"
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
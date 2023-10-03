variable "profile" {
  description = "The AWS profile aligned with the AWS environment to deploy to"
  type        = string
}

variable "resource_prefix" {
  description = "A prefix that should be attached to the names of resources"
  type        = string
}

variable "deploy_aws_nfw" {
  description = "enable nfw true/false"
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "mgmt_vpc_cidr" {
  description = "The CIDR range of the VPC"
  type        = string
}
variable "cidrs_for_remote_access" {
  description = "List of IPv4 CIDR ranges to access all admins remote access"
  type        = list(string)
}
variable "delete_protection" {
  description = "Whether or not to enable deletion protection of NFW"
  type        = bool
  default     = true
}
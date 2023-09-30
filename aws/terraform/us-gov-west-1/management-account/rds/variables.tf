variable "profile" {
  description = "The AWS profile aligned with the AWS environment to deploy to"
  type        = string
}

variable "resource_prefix" {
  description = "A prefix that should be attached to the names of resources"
  type        = string
}


variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}
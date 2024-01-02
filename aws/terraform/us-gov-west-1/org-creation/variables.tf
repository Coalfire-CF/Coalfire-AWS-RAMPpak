variable "service_access_principals" {
  description = "List of AWS Service Access Principals that you want to enable for organization integration"
  type        = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com"
  ]
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable in the Organization Root. Organization must have feature_set set to ALL."
}

variable "feature_set" {
  description = "Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED_BILLING."
  default     = "ALL"
}

variable "delegated_admin_account_id" {
  description = "The account ID number of the member account in the organization to register as a delegated administrator."
}

variable "delegated_service_principal" {
  description = "The service principal of the AWS service for which you want to make the member account a delegated administrator."
  default     = "principal"
}

variable "aws_new_member_account_name" {
  description = "The Friendly name for the member account."
  default     = null
}

variable "aws_new_member_account_email" {
  description = "The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account."
  default     = null
}

variable "ou_creation_info" {
  description = "list of names of OU to create and their corresponding delegated admins"
  default     = null
}

variable "aws_region" {
  type = string
}


variable "resource_prefix" {
  type = string
}

variable "finding_publishing_frequency" {
  type    = string
  default = "ONE_HOUR"
}

variable "aws_sec_hub_standards_arn" {
  type = list(string)
}

variable "aws_guardduty_datasources_enable_S3" {
  description = "Configuration for the collected datasources."
  default     = true
}

variable "aws_guardduty_datasources_enable_k8_audit_logs" {
  description = "Configuration for the collected datasources."
  default     = true
}

variable "aws_guardduty_datasources_enable_malware_protection_ebs" {
  description = "Configuration for the collected datasources."
  default     = true
}

variable "s3_kms_key_arn" {
  type = string
}

variable "create_org_config" {
  description = "True/False statement whether to enable AWS Config in the Organization"
  default     = true
}

variable "create_org_guardduty" {
  description = "True/False statement whether to enable AWS GuardDuty in the Organization"
  default     = true
}

variable "create_org_cloudtrail" {
  description = "True/False statement whether to enable AWS Cloudtrail in the Organization"
  default     = true
}

variable "create_org_securityhub" {
  description = "True/False statement whether to enable AWS Security Hub in the Organization"
  default     = true
}

variable "org_member_account_numbers" {
  default = null
}
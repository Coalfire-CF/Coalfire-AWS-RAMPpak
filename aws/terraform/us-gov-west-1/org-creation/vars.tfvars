service_access_principals = [
  "cloudtrail.amazonaws.com",
  "config.amazonaws.com",
  "securityhub.amazonaws.com",
  "guardduty.amazonaws.com",
"config-multiaccountsetup.amazonaws.com"]
enabled_policy_types       = ["SERVICE_CONTROL_POLICY"]
feature_set                = "ALL"
resource_prefix            = "pak"
org_member_account_numbers = ["1111111111111"]
delegated_admin_account_id = "1111111111111"
aws_region                 = "us-gov-west-1"
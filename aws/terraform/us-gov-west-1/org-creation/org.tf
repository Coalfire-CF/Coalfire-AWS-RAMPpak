module "org" {
  source = "github.com/Coalfire-CF/terraform-aws-organization"

  providers = {
    aws = aws.mgmt
  }

  feature_set = "ALL"
  aws_region                = var.default_aws_region
  aws_sec_hub_standards_arn = ["arn:${data.aws_partition.current.partition}:securityhub:${var.default_aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0", "arn:${data.aws_partition.current.partition}:securityhub:${var.default_aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"]
  resource_prefix           = var.resource_prefix
  s3_kms_key_arn            = data.terraform_remote_state.day0.outputs.s3_kms_key_arn
  org_member_account_numbers = ["358745275192"]
  delegated_admin_account_id = "358745275192"
  delegated_service_principal = "principal"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY", "BACKUP_POLICY", "TAG_POLICY"]
  service_access_principals = ["cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com"]
}

#
#resource "aws_organizations_organizational_unit" "ou" {
#  depends_on = [module.org-creation]
#  name      = "app_ou"
#  parent_id = module.org-creation.org_roots[0].id
#}
#
#
#resource "aws_organizations_resource_policy" "org_resource_policy" {
#  content = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "Statement",
#      "Effect": "Allow",
#      "Principal": {
#        "AWS": "arn:${data.aws_partition.current.partition}:iam::${module.org-creation.org_roots.id}:root"
#      },
#      "Action": [
#        "organizations:CreatePolicy",
#        "organizations:UpdatePolicy",
#        "organizations:DeletePolicy",
#        "organizations:AttachPolicy",
#        "organizations:DetachPolicy",
#        "organizations:EnablePolicyType",
#        "organizations:DisablePolicyType",
#        "organizations:DescribeOrganization",
#        "organizations:DescribeOrganizationalUnit",
#        "organizations:DescribeAccount",
#        "organizations:DescribePolicy",
#        "organizations:DescribeEffectivePolicy",
#        "organizations:ListRoots",
#        "organizations:ListOrganizationalUnitsForParent",
#        "organizations:ListParents",
#        "organizations:ListChildren",
#        "organizations:ListAccounts",
#        "organizations:ListAccountsForParent",
#        "organizations:ListPolicies",
#        "organizations:ListPoliciesForTarget",
#        "organizations:ListTargetsForPolicy",
#        "organizations:ListTagsForResource"
#      ],
#      "Resource": [
#        "arn:${data.aws_partition.current.partition}:organizations::${module.org-creation.org_roots.id}:ou/${aws_organizations_organizational_unit.ou[*].id}/*"]
#    }
#  ]
#}
#EOF
#}
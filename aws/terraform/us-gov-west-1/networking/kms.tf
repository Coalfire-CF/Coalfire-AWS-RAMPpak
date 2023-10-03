module "nfw_kms_key" {
  count = var.deploy_aws_nfw ? 1 : 0

  source = "github.com/Coalfire-CF/terraform-aws-kms"

  key_policy            = data.aws_iam_policy_document.nfw_kms_policy.json
  kms_key_resource_type = "nfw"
  resource_prefix       = var.resource_prefix
}

data "aws_iam_policy_document" "nfw_kms_policy" {
  provider = aws.mgmt

  statement {
    sid     = "Enable IAM User Permissions"
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]
  }
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]
  }
  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    principals {
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }
}
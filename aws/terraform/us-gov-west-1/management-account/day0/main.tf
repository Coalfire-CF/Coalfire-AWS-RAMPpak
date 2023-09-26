module "account-setup" {
  source = "github.com/Coalfire-CF/terraform-aws-account-setup"
  providers = {
    aws = aws.mgmt
  }

  resource_prefix = var.resource_prefix
  account_number = "${data.aws_caller_identity.current.account_id}"
  aws_region = var.aws_region
  default_aws_region = var.aws_region
  application_account_numbers = ["${data.aws_caller_identity.current.account_id}"]
}
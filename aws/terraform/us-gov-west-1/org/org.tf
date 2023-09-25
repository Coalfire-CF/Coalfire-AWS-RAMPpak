module "org" {
  source = "github.com/Coalfire-CF/terraform-aws-organization"

  aws_region                = var.default_aws_region
  aws_sec_hub_standards_arn = ""
  partition                 = data.aws_partition.current
  resource_prefix           = var.resource_prefix
  s3_kms_key_arn            = data.terraform_remote_state.day0.outputs.s3_kms_key_arn
}
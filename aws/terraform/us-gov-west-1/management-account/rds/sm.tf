module "secrets" {
  source = "github.com/Coalfire-CF/terraform-aws-secretsmanager"

  partition = data.aws_partition.current.partition
  names = ["rds-test"]
  length = 15
  #special = ""
  override_special = "$%&!"
  kms_key_id = data.terraform_remote_state.day0.outputs.sm_kms_key_id
  path = ""
  cross_account_ids = [""]
}


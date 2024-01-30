output "s3_tstate_bucket_name" {
  value = module.account-setup.s3_tstate_bucket_name
}

output "s3_kms_key_arn" {
  value = module.account-setup.s3_kms_key_arn
}

output "s3_kms_key_id" {
  value = module.account-setup.s3_kms_key_id
}

output "dynamo_kms_key_arn" {
  value = module.account-setup.dynamo_kms_key_arn
}

output "dynamo_kms_key_id" {
  value = module.account-setup.dynamo_kms_key_id
}

output "ebs_kms_key_arn" {
  value = module.account-setup.ebs_kms_key_arn[0]
}

output "ebs_kms_key_id" {
  value = module.account-setup.ebs_kms_key_id[0]
}

output "sm_kms_key_arn" {
  value = module.account-setup.sm_kms_key_arn[0]
}

output "sm_kms_key_id" {
  value = module.account-setup.sm_kms_key_id[0]
}

output "backup_kms_key_arn" {
  value = module.account-setup.backup_kms_key_arn[0]
}

output "backup_kms_key_id" {
  value = module.account-setup.backup_kms_key_id[0]
}

output "lambda_kms_key_arn" {
  value = module.account-setup.lambda_kms_key_arn[0]
}

output "lambda_kms_key_id" {
  value = module.account-setup.lambda_kms_key_id[0]
}

output "rds_kms_key_arn" {
  value = module.account-setup.rds_kms_key_arn[0]
}

output "rds_kms_key_id" {
  value = module.account-setup.rds_kms_key_id[0]
}

output "cloudwatch_kms_key_arn" {
  value = module.account-setup.cloudwatch_kms_key_arn[0]
}

output "cloudwatch_kms_key_id" {
  value = module.account-setup.cloudwatch_kms_key_id[0]
}

output "additional_kms_key_arns" {
  value = module.account-setup.additional_kms_key_arns
}

output "additional_kms_key_ids" {
  value = module.account-setup.additional_kms_key_ids
}

output "s3_access_logs_arn" {
  value = module.account-setup.s3_access_logs_arn
}

output "s3_backups_arn" {
  value = module.account-setup.s3_backups_arn
}

output "s3_installs_arn" {
  value = module.account-setup.s3_installs_arn
}

output "s3_access_logs_id" {
  value = module.account-setup.s3_access_logs_id
}

output "s3_backups_id" {
  value = module.account-setup.s3_backups_id
}

output "s3_installs_id" {
  value = module.account-setup.s3_installs_id
}

output "s3_elb_access_logs_arn" {
  value = module.account-setup.s3_elb_access_logs_arn
}

output "s3_elb_access_logs_id" {
  value = module.account-setup.s3_elb_access_logs_id
}

output "dynamodb_table_name" {
  value = module.account-setup.dynamodb_table_name
}
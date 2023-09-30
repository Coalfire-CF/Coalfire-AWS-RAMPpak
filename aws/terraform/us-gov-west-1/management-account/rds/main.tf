module "rds-test" {
  source = "github.com/Coalfire-CF/terraform-aws-rds?ref=draft"

  identifier        = local.name
  engine            = "postgres"
  engine_version    = "13.7"
  family            = "postgres13"
  instance_class    = "db.t3.large"
  allocated_storage = "50"
  #max_allocated_storage = "2000"
  storage_type      = "gp2"
  storage_encrypted = true
  kms_key_id        = data.terraform_remote_state.day0.outputs.rds_kms_key_arn

  db_name  = "rds_test"
  username = "testrds"
  password = module.secrets.secrets[index(module.secrets.names, "rds-test")]
  port     = "5432"

  subnet_ids             = [
    data.terraform_remote_state.networking.outputs.private_subnets[0],
    data.terraform_remote_state.networking.outputs.private_subnets[1]
  ]
  parameter_group_name   = "${var.resource_prefix}-${local.name}"
  db_subnet_group_name   = ""

  #availability_zone      = [""]
  multi_az               = "true"
  create_monitoring_role = true
  monitoring_interval    = 1
  monitoring_role_name   = "test_monitoring_role"

  allow_major_version_upgrade = "false"
  auto_minor_version_upgrade  = "false"
  apply_immediately           = "true"
  maintenance_window          = "Mon:00:00-Mon:03:00"
  skip_final_snapshot         = "true"
  copy_tags_to_snapshot       = "true"
  #final_snapshot_identifier   = "test-final-snapshot"

  backup_retention_period = "35"
  backup_window           = "09:46-10:16"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  deletion_protection = true

#  tags = merge(
#    local.tags,
#    var.global_tags
#  )
  db_instance_tags = {
    "OSFamily" = "Postgres"
    "OSType"   = "Linux"
    "App"      = "Management"
  }
  #db_parameter_group_tags = {}
#  db_subnet_group_tags = {
#    "backup_policy" = var.backup_policy
#  }
}
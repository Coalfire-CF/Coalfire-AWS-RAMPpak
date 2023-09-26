provider "aws" {
  region                 = var.aws_region
  skip_region_validation = "true"
  profile = "ooc-mgmt"
  alias = "mgmt"

  # FIPs endpoints for govcloud
  endpoints {
    appstream  = "appstream2-fips.${var.aws_region}.amazonaws.com"
    athena     = "athena-fips.${var.aws_region}.amazonaws.com"
    codebuild  = "codebuild-fips.${var.aws_region}.amazonaws.com"
    codecommit = "codecommit-fips.${var.aws_region}.amazonaws.com"
    codedeploy = "codedeploy-fips.${var.aws_region}.amazonaws.com"
    datasync   = "datasync-fips.${var.aws_region}.amazonaws.com"
    efs        = "elasticfilesystem-fips.${var.aws_region}.amazonaws.com"
    es         = "es-fips.${var.aws_region}.amazonaws.com"
    inspector  = "inspector-fips.${var.aws_region}.amazonaws.com"
    kms        = "kms-fips.${var.aws_region}.amazonaws.com"
    lambda     = "lambda-fips.${var.aws_region}.amazonaws.com"
    s3         = "s3-fips.${var.aws_region}.amazonaws.com"
    waf        = "waf-regional-fips.${var.aws_region}.amazonaws.com"
    workspaces = "workspaces-fips.${var.aws_region}.amazonaws.com"
  }
}
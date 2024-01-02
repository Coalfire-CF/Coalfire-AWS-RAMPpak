provider "aws" {
  region                 = var.default_aws_region
  skip_region_validation = "true"
  profile                = "pak-mgmt"
  alias                  = "mgmt"
  use_fips_endpoint      = true # FIPs endpoints for govcloud
}
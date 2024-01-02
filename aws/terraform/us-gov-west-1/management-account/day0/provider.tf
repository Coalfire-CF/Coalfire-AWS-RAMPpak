provider "aws" {
  region                 = var.aws_region
  skip_region_validation = "true"
  profile                = "mgmt"
  alias                  = "mgmt"
  use_fips_endpoint      = true
}
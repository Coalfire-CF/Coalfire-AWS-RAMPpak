data "terraform_remote_state" "day0" {
  backend = "s3"

  config = {
    bucket  = "${var.resource_prefix}-${var.default_aws_region}-tf-state"
    region  = var.default_aws_region
    key     = "${var.resource_prefix}-${var.default_aws_region}-tfsetup.tfstate"
    profile = "pak-mgmt"
  }
}
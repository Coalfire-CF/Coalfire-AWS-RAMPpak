terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
}
  backend "s3" {
    bucket         = "pak-us-gov-west-1-tf-state"
    region         = "us-gov-west-1"
    key            = "pak-us-gov-west-1-tfsetup.tfstate"
    dynamodb_table = "pak-us-gov-west-1-state-lock"
    encrypt        = true
  }
}
terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
}
#  backend "s3" {
#    role_arn       = "arn:aws-us-gov:iam::123627631951:role/tfadmin"
#    external_id    = "05e76a54-d94f-11ed-afa1-0242ac120002"
#    bucket         = "jab-opsstack-us-gov-west-1-fr-tf-state"
#    region         = "us-gov-west-1"
#    key            = "jab-opsstack-us-gov-west-1-tfsetup.tfstate"
#    dynamodb_table = "jab-opsstack-us-gov-west-1-state-lock"
#    encrypt        = true
#  }
}
#packer {
#  required_plugins {
#    amazon = {
#      version = ">= 1.1.1"
#      source = "github.com/hashicorp/amazon"
#    }
#  }
#}
#
#data "amazon-parameterstore" "subnet_id" {
#  name            = "/production/packer/subnet_id"
#  with_decryption = true
#  /* assume_role {
#      role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
#      session_name = "packer_session"
#  } */
#}
#data "amazon-parameterstore" "vpc_id" {
#  name            = "/production/packer/vpc_id"
#  with_decryption = true
#  /* assume_role {
#      role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
#      session_name = "packer_session"
#  } */
#}
#data "amazon-parameterstore" "prod_account_id" {
#  name            = "/production/packer/prod_account_id"
#  with_decryption = true
#  /* assume_role {
#      role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
#      session_name = "packer_session"
#  } */
#}
#data "amazon-parameterstore" "stage_account_id" {
#  name            = "/production/packer/stage_account_id"
#  with_decryption = true
#  /* assume_role {
#      role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
#      session_name = "packer_session"
#  } */
#}
#data "amazon-parameterstore" "kms_key_id" {
#  name            = "/production/packer/kms_key_id"
#  with_decryption = true
#  /* assume_role {
#      role_arn     = "arn:${var.partition}:iam::${var.builder_account_id}:role/packer_role"
#      session_name = "packer_session"
#  } */
#}

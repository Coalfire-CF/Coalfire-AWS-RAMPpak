# Global variables used by all Packer builds
aws_region  = "us-gov-west-1"
builder_account_id = "358745275192"  # OOC MGMT SANDBOX
partition = "aws-us-gov"
vpc_id = "vpc-0c6976ac88af7229e"
subnet_id = "subnet-0728afe1e13165d79"
ebs_kms_key_id = "arn:aws-us-gov:kms:us-gov-west-1:358745275192:key/fccd90c0-d74d-4ec9-bf97-8190d9f03899"
app_account_id1 = "358724425811"
app_account_id2 = "358723215008"

# These are to help with debugging
#ssh_keypair_name = "OOC-mgmt"
#ssh_private_key_file = "~/.ssh/OOC-mgmt.pem"
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["077303321853"]
  provider    = aws.mgmt

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-STIG-Full-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "win_bastion" {
  source = "github.com/Coalfire-CF/terraform-aws-ec2"

  name = var.instance_name

  ami               = data.aws_ami.ami.id
  ec2_instance_type = var.instance_size
  instance_count    = var.instance_count
  associate_eip     = var.associate_eip

  vpc_id          = data.terraform_remote_state.networking.outputs.mgmt_vpc_id
  subnet_ids      = [data.terraform_remote_state.networking.outputs.public_subnets["pak-mgmt-public-us-gov-west-1a"]]
  ec2_key_pair    = var.key_name
  ebs_kms_key_arn = data.terraform_remote_state.day0.outputs.ebs_kms_key_arn

  # Storage
  root_volume_size = var.instance_volume_size

  # Security Group Rules
  ingress_rules = [
    {
      protocol    = "tcp"
      from_port   = "3389"
      to_port     = "3389"
      cidr_blocks = [data.terraform_remote_state.networking.outputs.mgmt_vpc_cidr]
    }
  ]

  egress_rules = [{
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  # Tagging
  global_tags = {}

}


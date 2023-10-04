data "aws_partition" "current" {
  provider = aws.mgmt
}

data "aws_caller_identity" "current" {
  provider = aws.mgmt
}

data "aws_availability_zones" "available" {
  provider = aws.mgmt
  state    = "available"
}
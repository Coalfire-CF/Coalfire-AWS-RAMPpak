module "mgmt_subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "v1.0.0"

  base_cidr_block = var.mgmt_vpc_cidr
  networks = [
    {
      name     = "${var.resource_prefix}-firewall-1a"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-firewall-1b"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-firewall-1c"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-public-1a"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-public-1b"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-public-1c"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-compute-1a"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-compute-1b"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-compute-1c"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-private-1a"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-private-1b"
      new_bits = 8
    },
    {
      name     = "${var.resource_prefix}-private-1c"
      new_bits = 8
    }
  ]
}
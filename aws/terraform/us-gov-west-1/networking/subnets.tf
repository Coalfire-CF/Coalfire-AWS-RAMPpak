module "mgmt_subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "v1.0.0"

  base_cidr_block = var.mgmt_vpc_cidr
  networks = [
    {
      name     = "ooc-firewall-1a"
      new_bits = 8
    },
    {
      name     = "ooc-firewall-1b"
      new_bits = 8
    },
    {
      name     = "ooc-firewall-1c"
      new_bits = 8
    },
    {
      name     = "ooc-public-1a"
      new_bits = 8
    },
    {
      name     = "ooc-public-1b"
      new_bits = 8
    },
    {
      name     = "ooc-public-1c"
      new_bits = 8
    },
    {
      name     = "ooc-compute-1a"
      new_bits = 8
    },
    {
      name     = "ooc-compute-1b"
      new_bits = 8
    },
    {
      name     = "ooc-compute-1c"
      new_bits = 8
    },
    {
      name     = "ooc-private-1a"
      new_bits = 8
    },
    {
      name     = "ooc-private-1b"
      new_bits = 8
    },
    {
      name     = "ooc-private-1c"
      new_bits = 8
    }
  ]
}
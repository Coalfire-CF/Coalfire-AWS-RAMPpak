module "mgmt_subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "v1.0.0"

  base_cidr_block = var.mgmt_vpc_cidr
  networks = [
    {
      name     = "pak-firewall-1a"
      new_bits = 8
    },
    {
      name     = "pak-firewall-1b"
      new_bits = 8
    },
    {
      name     = "pak-firewall-1c"
      new_bits = 8
    },
    {
      name     = "pak-public-1a"
      new_bits = 8
    },
    {
      name     = "pak-public-1b"
      new_bits = 8
    },
    {
      name     = "pak-public-1c"
      new_bits = 8
    },
    {
      name     = "pak-compute-1a"
      new_bits = 8
    },
    {
      name     = "pak-compute-1b"
      new_bits = 8
    },
    {
      name     = "pak-compute-1c"
      new_bits = 8
    },
    {
      name     = "pak-private-1a"
      new_bits = 8
    },
    {
      name     = "pak-private-1b"
      new_bits = 8
    },
    {
      name     = "pak-private-1c"
      new_bits = 8
    }
  ]
}
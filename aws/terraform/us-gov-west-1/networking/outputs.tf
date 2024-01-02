output "mgmt_vpc_id" {
  description = "VPC id of deployed mgmt VPC"
  value       = module.mgmt_vpc.vpc_id
}

output "firewall_subnets" {
  description = "subnet ids of deployed firewall subnets"
  value       = module.mgmt_vpc.firewall_subnets
}

output "public_subnets" {
  description = "subnet ids of deployed public subnets"
  value       = module.mgmt_vpc.public_subnets
}

output "private_subnets" {
  description = "subnet ids of deployed private subnets"
  value       = module.mgmt_vpc.private_subnets
}

output "database_subnets" {
  description = "subnet ids of deployed firewall subnets"
  value       = module.mgmt_vpc.database_subnets
}

output "redshift_subnets" {
  description = "subnet ids of deployed public subnets"
  value       = module.mgmt_vpc.redshift_subnets
}

output "elasticache_subnets" {
  description = "subnet ids of deployed private subnets"
  value       = module.mgmt_vpc.elasticache_subnets
}

output "mgmt_vpc_cidr" {
  description = "mgmt vpc cidr block"
  value       = module.mgmt_vpc.vpc_cidr_block
}
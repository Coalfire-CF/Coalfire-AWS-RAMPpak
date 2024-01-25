output "accounts" {
  value       = module.org.accounts
  description = "List of org accounts including master"
}

output "org_roots" {
  value = module.org.org_roots
}

output "org_arn" {
  value = module.org.org_arn
}

output "org_id" {
  value = module.org.org_id
}

output "master_account_arn" {
  value = module.org.master_account_arn
}

output "ou_arn" {
  value = aws_organizations_organizational_unit.ou.arn
}

output "ou_id" {
  value = aws_organizations_organizational_unit.ou.id
}
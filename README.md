<div align="center">
<img src="coalfire_logo.png" width="200">

</div>

# Coalfire pak README Template

## Coalfire AWS RAMPpak


## Dependencies

- security-core
- account-setup

## Resource List

Insert a high-level list of resources created as a part of this module. E.g.

- AWS Organizations
- AWS Config
- AWS Backups
- AWS Cloudtrail
- AWS GuardDuty
- AWS Security Hub

## Code Updates

If applicable, add here. For example, updating variables, updating `tstate.tf`, or remote data sources.

`tstate.tf` Update to the appropriate version and storage accounts, see sample


``` hcl

data "terraform_remote_state" "usgv-ad" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = var.az_environment
    key                  = "${var.location_abbreviation}-ad.tfstate"
  }
}
```

## Deployment Steps

This module can be called as outlined below.

- Change directories to the `reponame` directory.
- From the `terraform/azure/reponame` directory run `terraform init`.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

Include example for how to call the module below with generic variables

```hcl
provider "azurerm" {
  features {}
}

module "core_sa" {
  source                    = "github.com/Coalfire-CF/ACE-Azure-StorageAccount?ref=vX.X.X"
  name                       = "${replace(var.resource_prefix, "-", "")}tfstatesa"
  resource_group_name        = azurerm_resource_group.management.name
  location                   = var.location
  account_kind               = "StorageV2"
  ip_rules                   = var.ip_for_remote_access
  diag_log_analytics_id      = azurerm_log_analytics_workspace.core-la.id
  virtual_network_subnet_ids = var.fw_virtual_network_subnet_ids
  tags                       = var.tags

  #OPTIONAL
  public_network_access_enabled = true
  enable_customer_managed_key   = true
  cmk_key_vault_id              = module.core_kv.id
  cmk_key_vault_key_name        = azurerm_key_vault_key.tfstate-cmk.name
  storage_containers = [
    "tfstate"
  ]
  storage_shares = [
    {
      name = "test"
      quota = 500
    }
  ]
  lifecycle_policies = [
    {
      prefix_match = ["tfstate"]
      version = {
        delete_after_days_since_creation = 90
      }
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.

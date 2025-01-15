```hcl
resource "azurerm_mssql_server_security_alert_policy" "security_alert_policies" {
  for_each = {
    for s in var.security_policies :
    s.server_name => s
  }


  resource_group_name = each.value.rg_name
  server_name         = each.value.server_name
  state               = try(each.value.state, "Enabled")

  storage_endpoint           = try(each.value.storage_endpoint, null)
  storage_account_access_key = try(each.value.storage_account_access_key, null)
  retention_days             = try(each.value.retention_days, 0)
  disabled_alerts            = try(each.value.disabled_alerts, [])
  email_account_admins       = try(each.value.email_account_admins, false)
  email_addresses            = try(each.value.email_addresses, [])
}

resource "azurerm_mssql_server_vulnerability_assessment" "vulnerability_assessment" {
  for_each = {
    for s in var.security_policies :
    s.server_name => s if s.vulnerability_assessment.enabled == true
  }

  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.security_alert_policies[each.key].id
  storage_container_path          = try(each.value.vulnerability_assessment.storage_container_path, null)
  storage_account_access_key      = try(each.value.vulnerability_assessment.storage_account_access_key, null)
  storage_container_sas_key       = try(each.value.vulnerability_assessment.storage_container_sas_key, null)

  dynamic "recurring_scans" {
    for_each = can(each.value.vulnerability_assessment.recurring_scans) && each.value.vulnerability_assessment.recurring_scans != null ? [each.value.vulnerability_assessment.recurring_scans] : []
    content {
      enabled                   = try(recurring_scans.value.enabled, true)
      email_subscription_admins = try(recurring_scans.value.email_subscription_admins, false)
      emails                    = try(recurring_scans.value.emails, [])
    }
  }
}

```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_server_security_alert_policy.security_alert_policies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.vulnerability_assessment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_security_policies"></a> [security\_policies](#input\_security\_policies) | The security policies to apply to the database | <pre>list(object({<br/>    rg_name                    = string<br/>    server_name                = string<br/>    state                      = optional(string, "Enabled")<br/>    disabled_alerts            = optional(list(string), [])<br/>    email_account_admins       = optional(bool, false)<br/>    email_addresses            = optional(list(string), [])<br/>    retention_days             = optional(number, 0)<br/>    storage_account_access_key = optional(string)<br/>    storage_endpoint           = optional(string)<br/><br/>    vulnerability_assessment = optional(object({<br/>      enabled                    = optional(bool, false)<br/>      storage_container_path     = optional(string)<br/>      storage_account_access_key = optional(string)<br/>      storage_container_sas_key  = optional(string)<br/><br/>      recurring_scans = optional(object({<br/>        enabled                   = optional(bool, true)<br/>        email_subscription_admins = optional(bool, false)<br/>        emails                    = optional(list(string), [])<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.

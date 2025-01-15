variable "security_policies" {
  description = "The security policies to apply to the database"
  type = list(object({
    rg_name                    = string
    server_name                = string
    state                      = optional(string, "Enabled")
    disabled_alerts            = optional(list(string), [])
    email_account_admins       = optional(bool, false)
    email_addresses            = optional(list(string), [])
    retention_days             = optional(number, 0)
    storage_account_access_key = optional(string)
    storage_endpoint           = optional(string)

    vulnerability_assessment = optional(object({
      enabled                    = optional(bool, false)
      storage_container_path     = optional(string)
      storage_account_access_key = optional(string)
      storage_container_sas_key  = optional(string)

      recurring_scans = optional(object({
        enabled                   = optional(bool, true)
        email_subscription_admins = optional(bool, false)
        emails                    = optional(list(string), [])
      }))
    }))
  }))
}

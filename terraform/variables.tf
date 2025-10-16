variable "resource_group" {
    type = list(object({
    name      = string
    location  = string
    enabled   = bool
  }))
}

variable "lb_name" {
  type        = string
  default     = "eastus2"
  description = "Load balancer name"
}

variable "lb_frontend_ip_name" {
  type        = string
  default     = "eastus2"
  description = "Load balacer front end IP address name"
}

variable "lb_probe1_port" {
  type        = number
  default     = "80"
  description = "Load balancer probe 1 port number"
}

variable "virtual_machine" {
  type = list(object({
    name            = string
    os_type         = string
    size            = string
    admin_username  = string
    admin_password  = string
    os_image        = string
    lb_enable       = bool
  }))

  validation {
    condition = alltrue([
      for vm in var.virtual_machine :
      lower(vm.os_type) == "linux" || lower(vm.os_type) == "windows"
    ])
    error_message = "The allowed vaules for 'os_type' must be either 'linux' or 'windows'."
  }
}

variable "virtual_network" {
  type = list(object({
    name                = string
    vnet_address_space  = list(string)
    snet_name           = string
    snet_address_prefix = string
  }))
}

variable "tags" {
    type = list(object({
    Environment         = string
    Owner               = string
    application         = string
    application_tier    = string
    application_owner   = string
    app_role            = string
    shared              = string
    snow_support        = string
    group               = string
    costcenter          = string
    hfm_entity          = string
    division            = string
    data_classification = string
    compliance          = string
    review_date         = string
  }))
}

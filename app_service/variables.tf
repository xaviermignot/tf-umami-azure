variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "app_settings" {
  type = map(string)
}

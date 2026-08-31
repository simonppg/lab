variable "truenas_url" {
  type = string
}

variable "truenas_api_key" {
  type      = string
  sensitive = true
}

variable "truenas_username" {
  type      = string
  sensitive = true
}

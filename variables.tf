variable "virtual_environment_endpoint" {
  type        = string
  description = "The endpoint for the Proxmox Virtual Environment API"
}

variable "virtual_environment_token" {
  type        = string
  description = "The token for the Proxmox Virtual Environment API"
  sensitive = true
}

variable "user_account_username" {
  type        = string
  description = "The username for authorization on virtual machine"
}

variable "user_account_password" {
  type        = string
  description = "The password for authorization on virtual machine"
  sensitive = true
}

variable "ssh_ve_username" {
  type        = string
  description = "The username for the Proxmox Virtual Environment SSH"
}

variable "ssh_ve_password" {
  type        = string
  description = "The password for the Proxmox Virtual Environment SSH"
  sensitive = true
}
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.38.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

data "sops_file" "global_secrets" {
  source_file = "secret.sops.yaml"
}

provider "sops" {}

provider "proxmox" {
  endpoint  = data.sops_file.global_secrets.data["proxmox.endpoint"]
  api_token = data.sops_file.global_secrets.data["proxmox.api_token"]
  insecure  = true
  ssh {
    agent    = true
    username = data.sops_file.global_secrets.data["proxmox.ssh_ve_username"]
    password = data.sops_file.global_secrets.data["proxmox.ssh_ve_password"]
  }
}

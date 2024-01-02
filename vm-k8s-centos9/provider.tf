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
    dns = {
      source = "hashicorp/dns"
      version = "3.4.0"
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

provider dns {
  update {
    server        = "192.168.8.5"
    key_name      = "tsig-key."
    key_algorithm = "hmac-sha256"
    key_secret    = "${data.sops_file.global_secrets.data["dns.key_secret"]}"
  }
}
resource "proxmox_virtual_environment_vm" "centos_vm" {
  name      = "test-centos"
  node_name = "pve"

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = var.user_account_username
      password = var.user_account_password
    }
  }
  network_device {
    bridge = "vmbr0"
  }
  cpu {
    cores = 2
    numa  = true
  }
  memory {
    dedicated = "2048"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.centos_cloud_image.id
    interface    = "scsi0"
    size         = 10
  }
}

resource "proxmox_virtual_environment_file" "centos_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path      = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20231113.0.x86_64.qcow2"
    file_name = "centos8.img"
  }
}
resource "proxmox_virtual_environment_vm" "kube-master" {
  for_each  = var.masters
  name      = each.key
  node_name = each.value.target_node
  vm_id     = each.value.id
  migrate   = true
  
  initialization {
    datastore_id      = each.value.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.user_data[each.key].id
    
    dns {
      domain = var.common.search_domain
      server = var.common.nameserver
    }

    ip_config {
      ipv4 {
        address = each.value.cidr
        gateway = var.common.gw
      }
    }
  }
  
  network_device {
    bridge      = "vmbr0"
    mac_address = each.value.macaddr
    model       = "virtio"
    #vlan_id     = 30
    firewall    = false
    mtu         = 1500
    queues      = 0
    rate_limit  = 0
  }
  
  cpu {
    cores   = each.value.cores
    numa    = true
    sockets = each.value.sockets
    type    = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  vga {
    type   = "qxl"
    memory = 4
  }

  disk {
    datastore_id = each.value.datastore_id
    file_id      = proxmox_virtual_environment_file.centos_cloud_image.id
    interface    = each.value.interface
    size         = each.value.disk
    discard      = "on"
    cache        = "writeback"
    ssd          = true
  }
}
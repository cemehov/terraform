resource "proxmox_virtual_environment_vm" "dns_server" {
  for_each  = var.dns-servers
  name      = each.key
  node_name = each.value.target_node
  vm_id     = each.value.id
  #migrate   = true
  
  initialization {
    datastore_id      = each.value.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.user_data[each.key].id
    network_data_file_id = proxmox_virtual_environment_file.network_data[each.key].id
    
    # dns {
    #   domain = var.common.search_domain
    #   server = var.common.dns_server 
    # }

    # ip_config {
    #   ipv4 {
    #     address = each.value.cidr
    #     gateway = var.common.gw
    #   }
    # }
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

  connection {
    type     = "ssh"
    user     = var.common.username
    host     = each.value.primary_ip
    port     = 22
    password = data.sops_file.secrets.data["ssh.password"]
    # private_key = data.sops_file.secrets.data["ssh.private_key"]
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install bind bind-utils -y",
      "mkdir /tmp/named"
    ]
  }

  provisioner "file" {
    source      = "files/named.conf"
    destination = "/tmp/named/named.conf"
  }

  provisioner "file" {
    source      = "files/home.lab"
    destination = "/tmp/named/home.lab"
  }

  # provisioner "file" {
  #   source      = "files/8"
  #   destination = "/tmp/named/8"
  # }

  provisioner "file" {
    content      = <<EOF
key "tsig-key" {
        algorithm hmac-sha256;
        secret "${data.sops_file.secrets.data["dns.key_secret"]}";
};
EOF
    destination = "/tmp/named/tsig.key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/named/named.conf /etc",
      "sudo mv /tmp/named/{home.lab,tsig.key} /var/named",
      "sudo systemctl restart named",
      "sudo systemctl enable named"
    ]
  }

}
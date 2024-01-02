data "template_file" "user_data" {
  for_each = merge(var.dns-servers)

  template = file("${path.module}/files/user-data.yaml")
  vars     = {
    username           = var.common.username
    password           = data.sops_file.secrets.data["ssh.sha_password"]
    ssh_public_key     = data.sops_file.secrets.data["ssh.public_key"]
    node_hostname      = "${each.key}"
    node_domain_search = "${var.common.search_domain}"
  }
}

data template_file "network_data" {
  for_each = merge(var.dns-servers)
  template = file("${path.module}/files/network-data.yaml")
  vars = {
    node_domain_search = var.common.search_domain
    node_ip       = each.value.cidr
    node_gateway  = var.common.gw
    node_primary_dns      = var.common.primary_nameserver
    node_secondary_dns    = var.common.secondary_nameserver
    node_mac_address      = each.value.macaddr
  }
}

resource "local_file" "user_data" {
  for_each     = merge(var.dns-servers)
  content      = data.template_file.user_data[each.key].rendered
  filename     = "${path.module}/files/vm-${each.value.id}-user-data.yaml"
}

resource "local_file" "network_data" {
  for_each = merge(var.dns-servers)
  content  = data.template_file.network_data[each.key].rendered
  filename = "${path.module}/files/vm-${each.value.id}-network-data.yaml"
}

resource "proxmox_virtual_environment_file" "user_data" {
  for_each     = merge(var.dns-servers)
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = "pve"

  source_file {
    path = "${path.module}/files/vm-${each.value.id}-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_file" "network_data" {
  for_each     = merge(var.dns-servers)
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = "pve"

  source_file {
    path = "${path.module}/files/vm-${each.value.id}-network-data.yaml"
  }
}
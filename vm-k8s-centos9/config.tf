data "template_file" "user_data" {
  for_each = merge(var.masters,var.workers)

  template = file("${path.module}/files/user-data.yaml")
  vars     = {
    username           = var.common.username
    password           = data.sops_file.secrets.data["ssh.password"]
    ssh_public_key     = data.sops_file.secrets.data["ssh.public_key"]
    node_hostname      = "${each.key}"
    node_domain_search = "${var.common.search_domain}"
  }
}

resource "local_file" "user_data" {
  for_each     = merge(var.masters,var.workers)
  content      = data.template_file.user_data[each.key].rendered
  filename     = "${path.module}/files/vm-${each.value.id}-user-data.yaml"
}

resource "proxmox_virtual_environment_file" "user_data" {
  for_each     = merge(var.masters,var.workers)
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = "pve"

  source_file {
    path = "${path.module}/files/vm-${each.value.id}-user-data.yaml"
  }
}

resource "dns_a_record_set" "k8s-centos8-master01" {
  for_each = merge(var.masters,var.workers)
  zone = "home.lab."
  name = each.key
  addresses = ["${each.value.primary_ip}"]
  ttl = 300
}
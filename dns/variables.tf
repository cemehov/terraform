variable "common" {
  type = map(string)
  default = {
    search_domain           = "home.lab"
    primary_nameserver      = "192.168.8.5"
    username                = "user"
    gw                      = "192.168.8.1"
    secondary_nameserver    = "1.1.1.1"
  }
}

variable "dns-servers" {
  type = map(map(string))
  default = {
    dns1 = {
      id            = 3005
      primary_ip    = "192.168.8.5"
      cidr          = "192.168.8.5/24"
      cidr6         = "fe80::be24:11ff:fe30:51d8"
      sockets       = 1
      vcpus         = 2
      cores         = 2
      macaddr       = "bc:24:11:30:51:d8"
      memory        = 2*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node   = "pve"
    }
  }
}
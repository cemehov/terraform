variable "common" {
  type = map(string)
  default = {
    search_domain   = "home.lab"
    nameserver      = "192.168.8.5"
    username        = "user"
    gw              = "192.168.8.1"
    dns_server      = "1.1.1.1"
  }
}

variable "masters" {
  type = map(map(string))
  default = {
    master01 = {
      id            = 3031
      primary_ip    = "192.168.8.31"
      cidr          = "192.168.8.31/24"
      cidr6         = "fe80::be24:11ff:fe30:51d9"
      sockets       = 1
      vcpus         = 2
      cores         = 2
      macaddr       = "bc:24:11:30:51:d9"
      memory        = 2*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node   = "pve"
    },
    master02 = {
      id            = 3032
      primary_ip    = "192.168.8.32"
      cidr          = "192.168.8.32/24"
      cidr6         = "fe80::be24:11ff:fefe:55c6"
      sockets       = 1
      vcpus         = 2
      cores         = 2
      macaddr       = "bc:24:11:fe:55:c6"
      memory        = 2*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node = "pve"
    },
    master03 = {
      id            = 3033
      primary_ip    = "192.168.8.33"
      cidr          = "192.168.8.33/24"
      cidr6         = "fe80::be24:11ff:fed8:b552"
      sockets       = 1
      vcpus         = 2
      cores         = 2
      macaddr       = "bc:24:11:d8:b5:52"
      memory        = 2*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node = "pve"
    }
  }
}

variable "workers" {
  type = map(map(string))
  default = {
    worker01 = {
      id            = 3034
      primary_ip    = "192.168.8.34"
      cidr          = "192.168.8.34/24"
      cidr6         = "fe80::be24:11ff:fef5:5714"
      sockets       = 1
      vcpus         = 6
      cores         = 6
      macaddr       = "bc:24:11:f5:57:14"
      memory        = 8*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node = "pve"
    },
    worker02 = {
      id            = 3035
      primary_ip    = "192.168.8.35"
      cidr          = "192.168.8.35/24"
      cidr6         = "fe80::be24:11ff:fe99:28b3"
      sockets       = 1
      vcpus         = 6
      cores         = 6
      macaddr       = "bc:24:11:99:28:b3"
      memory        = 8*1024
      disk          = "20"
      disk_iothread = 0
      datastore_id  = "local-lvm"
      interface     = "scsi0"
      target_node = "pve"
    }
  }
}
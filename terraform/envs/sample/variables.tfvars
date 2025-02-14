common = {
  bastion_host  = "ubuntu.dy2k.io"
  os_template   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  os_type       = "ubuntu"
  clone         = "ci-ubuntu-template"
  search_domain = "sd-51798.dy2k.io"
  target_node   = "sd-51798"
  nameserver    = "10.0.0.1"
  tags          = ""
}

gateways = {
  gateway1 = {
    target_node = "node01"
    id          = 101
    cores       = 2
    memory      = 2048
    disk        = 16
    storage     = "Storage-ZFS"
    network = [
      {
        cidr   = "10.0.0.1/24"
        name   = "eth0"
        gw     = ""
        hwaddr = "06:08:72:DD:89:B4"
        ip     = "10.0.0.1"
        tag    = 0
      },
      {
        cidr   = "163.172.118.179/32"
        name   = "eth1"
        gw     = "62.210.0.1"
        hwaddr = "52:54:00:00:bc:0b"
        tag    = 0
      }
  ] },
  gateway2 = {
    target_node = "node01"
    id          = 102
    cores       = 2
    memory      = 2048
    disk        = 16
    storage     = "Storage-ZFS"
    network = [
      {
        cidr   = "10.0.0.2/24"
        name   = "eth0"
        gw     = "10.0.0.1"
        hwaddr = "E6:48:8F:0C:D0:57"
        ip     = "10.0.0.2"
        tag    = 0
      }
  ] }
}

masters = {
  kube-master1 = {
    target_node = "node01"
    id          = 201
    cidr        = "10.0.0.11/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "6E:DE:EE:62:37:1D"
    ip          = "10.0.0.11"
    net_id      = 0
    tag         = 0
    memory      = 2048
    disk        = "40G"
    storage     = "Storage-ZFS"
  },
  kube-master2 = {
    target_node = "node01"
    id          = 202
    cidr        = "10.0.0.12/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "2E:6E:FC:F0:A1:CB"
    ip          = "10.0.0.12"
    net_id      = 0
    tag         = 0
    memory      = 2048
    disk        = "40G"
    storage     = "Storage-ZFS"
  },
  kube-master3 = {
    target_node = "node01"
    id          = 203
    cidr        = "10.0.0.13/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "6A:83:72:97:97:81"
    ip          = "10.0.0.13"
    net_id      = 0
    tag         = 0
    memory      = 2048
    disk        = "40G"
    storage     = "Storage-ZFS"
  }
}

workers = {
  kube-worker1 = {
    target_node = "node01"
    id          = 301
    cidr        = "10.0.0.21/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "62:0E:E4:E4:7B:46"
    ip          = "10.0.0.21"
    net_id      = 0
    tag         = 0
    memory      = 5120
    disk        = "80G"
    storage     = "Storage-ZFS"
  },
  kube-worker2 = {
    target_node = "node01"
    id          = 302
    cidr        = "10.0.0.22/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "5A:B1:D9:D1:E6:35"
    ip          = "10.0.0.22"
    net_id      = 0
    tag         = 0
    memory      = 5120
    disk        = "80G"
    storage     = "Storage-ZFS"
  },
  kube-worker3 = {
    target_node = "node01"
    id          = 303
    cidr        = "10.0.0.23/24"
    cores       = 2
    gw          = "10.0.0.1"
    macaddr     = "22:92:5D:6B:7F:A1"
    ip          = "10.0.0.23"
    net_id      = 0
    tag         = 0
    memory      = 5120
    disk        = "80G"
    storage     = "Storage-ZFS"
  },
}

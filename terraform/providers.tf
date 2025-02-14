terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
    tls = {
      version = "4.0.6"
    }
    random = {
      version = "3.6.3"
    }
    local = {
      version = "2.5.2"
    }
  }
}

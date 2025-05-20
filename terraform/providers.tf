terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc9"
    }
    tls = {
      version = "4.1.0"
    }
    random = {
      version = "3.7.2"
    }
    local = {
      version = "2.5.3"
    }
  }
}

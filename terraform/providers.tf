terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "~> 2.9.14"
    }
    tls = {
      version = "~> 4.0.4"
    }
    random = {
      version = "~> 3.5.1"
    }
    local = {
      version = "~> 2.4.0"
    }
  }
}
resource "proxmox_vm_qemu" "kube-master" {
  for_each = var.masters

  name         = each.key
  target_node  = each.value.target_node
  agent        = 1
  vmid         = each.value.id
  memory       = each.value.memory
  onboot       = true
  bootdisk     = "scsi0"
  scsihw       = "virtio-scsi-pci"
  os_type      = "cloud-init"
  ipconfig0    = "ip=${each.value.cidr},gw=${each.value.gw}"
  ciuser       = "terraform"
  cipassword   = yamldecode(data.local_file.secrets.content).user_password
  searchdomain = var.common.search_domain
  nameserver   = var.common.nameserver
  tags         = var.common.tags
  clone = join("", [
    each.value.target_node,
    "-",
    var.common.clone
  ])
  sshkeys = join("", [
    data.tls_public_key.dy2k.public_key_openssh,
    data.tls_public_key.ubuntu_terraform.public_key_openssh,
    yamldecode(data.local_file.secrets.content).ssh_authorized_keys
  ])

  cpu {
    cores    = each.value.cores
    type     = "host"
  }

  vga {
    type = "qxl"
  }

  network {
    id       = each.value.net_id
    model    = "virtio"
    macaddr  = each.value.macaddr
    bridge   = "vmbr0"
    firewall = true
    tag      = each.value.tag
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = each.value.storage
          size    = each.value.disk
          format  = "qcow2"
        }
      }
      scsi1 {
        cloudinit {
          storage = each.value.storage
        }
      }
    }
  }

  serial {
    id   = 0
    type = "socket"
  }

  timeouts {
    create = "240s"
    update = "2h"
    delete = "20m"
  }

  depends_on = [
    proxmox_lxc.gateway
  ]

  connection {
    host        = each.value.ip
    user        = "terraform"
    private_key = data.tls_public_key.ubuntu_terraform.private_key_pem
    bastion_host        = var.common.bastion_host
    bastion_private_key = data.tls_public_key.dy2k.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo usermod --password $(openssl passwd -1 ${yamldecode(data.local_file.secrets.content).root_password}}) root",
      "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N \"\"",
      "echo \"${data.tls_public_key.ubuntu_terraform.private_key_pem}\" > ~/.ssh/id_rsa",
      "echo \"${data.tls_public_key.ubuntu_terraform.public_key_openssh}\" > ~/.ssh/id_rsa.pub",
      "echo \"${yamldecode(data.local_file.secrets.content).ssh_authorized_keys}\" >> /home/terraform/.ssh/authorized_keys",
    ]
  }
}

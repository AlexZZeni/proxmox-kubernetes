resource "proxmox_vm_qemu" "kube-worker" {
  for_each = var.workers

  name         = each.key
  target_node  = each.value.target_node
  agent        = 1
  vmid         = each.value.id
  memory       = each.value.memory
  cores        = each.value.cores
  onboot       = true
  bootdisk     = "scsi0"
  scsihw       = "virtio-scsi-pci"
  os_type      = "cloud-init"
  ipconfig0    = "ip=${each.value.cidr},gw=${each.value.gw}"
  ciuser       = "terraform"
  cipassword   = yamldecode(data.local_file.secrets.content).user_password
  searchdomain = var.common.search_domain
  nameserver   = var.common.nameserver
  clone = var.common.clone
  sshkeys = join("", [
    data.tls_public_key.dy2k.public_key_openssh,
    data.tls_public_key.ubuntu_terraform.public_key_openssh
  ])

  vga {
    type = "qxl"
  }

  network {
    model    = "virtio"
    macaddr  = each.value.macaddr
    bridge   = "vmbr0"
    firewall = true
    tag      = each.value.tag
  }

  disk {
    type    = "scsi"
    storage = each.value.storage
    size    = each.value.disk
    format  = "qcow2"
  }

  serial {
    id   = 0
    type = "socket"
  }

  timeouts {
    create = "240s"
  }

  depends_on = [
    proxmox_vm_qemu.kube-master
  ]

  connection {
    host                = each.value.ip
    user                = "terraform"
    private_key         = data.tls_public_key.ubuntu_terraform.private_key_pem
    bastion_host        = var.common.bastion_host
    bastion_private_key = data.tls_public_key.dy2k.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo usermod --password $(openssl passwd -1 ${yamldecode(data.local_file.secrets.content).root_password}}) root",
      "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N \"\"",
      "echo \"${data.tls_public_key.ubuntu_terraform.private_key_pem}\" > ~/.ssh/id_rsa",
      "echo \"${data.tls_public_key.ubuntu_terraform.public_key_openssh}\" > ~/.ssh/id_rsa.pub",
    ]
  }
}

resource "proxmox_lxc" "gateway" {
  for_each = var.gateways

  ostemplate   = var.common.os_template
  ostype       = var.common.os_type
  cores        = each.value.cores
  hostname     = each.key
  vmid         = each.value.id
  memory       = each.value.memory
  swap         = 2048
  onboot       = true
  start        = true
  unprivileged = true
  target_node  = each.value.target_node
  password     = yamldecode(data.local_file.secrets.content).root_password
  searchdomain = var.common.search_domain
  ssh_public_keys = join("", [
    data.tls_public_key.dy2k.public_key_openssh,
    data.tls_public_key.ubuntu_terraform.public_key_openssh
  ])

  dynamic "network" {
    for_each = each.value.network
    content {
      name     = network.value.name
      bridge   = "vmbr0"
      firewall = true
      gw       = network.value.gw
      hwaddr   = network.value.hwaddr
      ip       = network.value.cidr
      rate     = 0
      tag      = network.value.tag
      type     = "veth"
    }
  }

  rootfs {
    storage = each.value.storage
    size    = "${each.value.disk}G"
  }


  connection {
    host                = each.value.network[0].ip
    private_key         = data.tls_public_key.ubuntu_terraform.private_key_pem
    bastion_host        = var.common.bastion_host
    bastion_private_key = data.tls_public_key.dy2k.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "adduser --disabled-password --gecos \"\" terraform && usermod -aG sudo terraform",
      "usermod --password $(openssl passwd -1 ${yamldecode(data.local_file.secrets.content).user_password}}) terraform",
      "echo 'terraform ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers.d/terraform && chmod 440 /etc/sudoers.d/terraform",
      "su - terraform -c 'ssh-keygen -b 2048 -t rsa -f /home/terraform/.ssh/id_rsa -q -N \"\"'",
      "echo \"${data.tls_public_key.ubuntu_terraform.private_key_pem}\" > /home/terraform/.ssh/id_rsa",
      "echo \"${data.tls_public_key.ubuntu_terraform.public_key_openssh}\" > /home/terraform/.ssh/id_rsa.pub",
      "echo \"${data.tls_public_key.ubuntu_terraform.public_key_openssh}\" >> /home/terraform/.ssh/authorized_keys",
      "echo \"${data.tls_public_key.dy2k.public_key_openssh}\" >> /home/terraform/.ssh/authorized_keys",
      "chown terraform:terraform /home/terraform/.ssh/authorized_keys && chmod 700 /home/terraform/.ssh/authorized_keys"
    ]
  }
}

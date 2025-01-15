# VM Helper

## Cloud-init Template

Virtual machines provisioned are initialized using [Cloud-init](https://pve.proxmox.com/wiki/Cloud-Init_Support). You need to create a cloud-init image and convert it to a VM template in order to further clone in the Terraform Proxmox [provider](https://github.com/Telmate/terraform-provider-proxmox) into VMs, resizing the disk, and configuring the default user, passwords, SSH keys and network. To prepare the template, you may use the following commands.

- ID 9001 - Ubuntu 20.04 (Focal Fossa)
- ID 9011 - Ubuntu 22.04 (Jammy)
- ID 9021 - Ubuntu 18.04 (Bionic)
- ID 9031 - Ubuntu 24.04 (Noble Numbat)

```bash
# Download the ubuntu cloud image
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

# Create a new VM with ID 9001
qm create 9001 --memory 2048 --net0 virtio,bridge=vmbr0
qm create 9011 --memory 2048 --net0 virtio,bridge=vmbr0
qm create 9021 --memory 2048 --net0 virtio,bridge=vmbr0
qm create 9031 --memory 2048 --net0 virtio,bridge=vmbr0

# Import the downloaded disk to local storage with qcow2 format
qm importdisk 9001 focal-server-cloudimg-amd64.img local --format qcow2
qm importdisk 9011 jammy-server-cloudimg-amd64.img local --format qcow2
qm importdisk 9021 bionic-server-cloudimg-amd64.imglocal --format qcow2
qm importdisk 9031 noble-server-cloudimg-amd64.imglocal --format qcow2

# Attach the new disk to the VM as scsi drive
qm set 9001 --scsihw virtio-scsi-pci --scsi0 local:9001/vm-9001-disk-0.qcow2
qm set 9011 --scsihw virtio-scsi-pci --scsi0 local:9011/vm-9011-disk-0.qcow2
qm set 9021 --scsihw virtio-scsi-pci --scsi0 local:9021/vm-9021-disk-0.qcow2
qm set 9031 --scsihw virtio-scsi-pci --scsi0 local:9031/vm-9031-disk-0.qcow2

# Add Cloud-Init CDROM drive
qm set 9001 --ide2 local:cloudinit
qm set 9011 --ide2 local:cloudinit
qm set 9021 --ide2 local:cloudinit
qm set 9031 --ide2 local:cloudinit

# Speed up booting by setting the bootdisk parameter
qm set 9001 --boot c --bootdisk scsi0
qm set 9011 --boot c --bootdisk scsi0
qm set 9021 --boot c --bootdisk scsi0
qm set 9031 --boot c --bootdisk scsi0

# Configure a serial console for display
qm set 9001 --serial0 socket --vga serial0
qm set 9011 --serial0 socket --vga serial0
qm set 9021 --serial0 socket --vga serial0
qm set 9031 --serial0 socket --vga serial0

# Convert the VM into a template
qm template 9001
qm template 9011
qm template 9021
qm template 9031
```

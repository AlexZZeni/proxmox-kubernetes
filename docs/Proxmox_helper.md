# Proxmox Helper

## Terraform User and Token in Proxmox

To create the user/role

```bash
pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"

pveum user add terraform-prov@pve --password <password>

pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

To modify the user/role

```bash
pveum role modify TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"
```

To create the token for the terraform user go to **Datacenter -> Permissons -> API Tokens**
and create a new token with the following fields:

- User: terraform-prov@pve
- Token ID: terraform
- Privilege Separation: Uncheked
- Expire: never

## Metrics User and Token in Proxmox

To create the user/role

```bash
pveum role add MetricsServices -privs "Datastore.Audit Pool.Audit SDN.Audit Sys.Audit VM.Audit"

pveum user add metrics-info@pve --password <password>

pveum aclmod / -user metrics-info@pve -role MetricsServices
```

To create the token for the terraform user go to **Datacenter -> Permissons -> API Tokens**
and create a new token with the following fields:

- User: metrics-info@pve
- Token ID: metrics
- Privilege Separation: Uncheked
- Expire: never

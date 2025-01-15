# LXC Helper

## Container Template

LXC [containers](https://pve.proxmox.com/wiki/Linux_Container) are used to create the DNS and load balancers. You may update available containers and download the required template with the cluster shell in the console as follows.

```bash
# Update the container template database
pveam update

# Download the ubuntu container template
pveam download local ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz
pveam download local ubuntu-20.04-standard_20.04-1_amd64.tar.gz
pveam download local ubuntu-22.04-standard_22.04-1_amd64.tar.zst
pveam download local ubuntu-24.04-standard_24.04-2_amd64.tar.zst
```

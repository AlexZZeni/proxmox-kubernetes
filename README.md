
# Kubernetes on Proxmox

Using Terraform and Ansible to provision Proxmox VMs and configure a highly available Kubernetes cluster with co-located control plane nodes and etcd members.

## Features

- Two `gateways` LXC machines for the DNS servers and the load balancers of kube-apiserver
- Three `masters` QEMU VM machines for the Kubernetes control-plane nodes
- Three `workers` QEMU VM machines for the Kubernetes worker nodes
- Setup NAT gateway with the assigned public IP on the first `gateways` machine
- Disable swap and ensure iptables see bridged traffic for `masters` and `workers`
- Install QEMU guest agent, setup timezone, disable SSH password and IPv6
- Setup SSH key, configure root password and use `terraform` as default sudo user

## Prerequisite

Terraform and Ansible is required to run the provisioning and configuration tasks. You may install them on macOS using Homebrew.

```bash
brew install terraform ansible
```

Alternatively you may prepare your Ansible environment using `virtualenv`.

```bash
# Use python3 instead of the default python come with macOS
brew install python3

# Install virtualenv with pip3
pip3 install virtualenv

# Create new python virtual environment in .ansible directory
virtualenv .ansible

# Activate the virtual environment according to your shell (e.g. fish)
. .ansible/bin/activate.fish
```

## Terraform Secrets

The passwords and SSH keys used by Terraform are retrieved from the `terraform/envs/.terraform_secret.yaml` file. You may generate new passwords and SSH keys with the following commands.

```bash
# Create a random password with length 24
openssl rand -base64 24

# Create a RSA ssh key in PEM format with comment and file path
ssh-keygen -t rsa -b 4096 -N "" -C "$USERNAME@$DOMAIN" -m pem -f "$PRIVATE_KEY"
```

For the full list of required passwords and SSH keys, you may refer to the below sample configuration.

```yaml
# Proxmox API host URL
pm_api_url: https://<api_host>:8006/api2/json
# Proxmox user (e.g. root@pam)
pm_user: <api_user>
# Proxmox password
pm_password: <api_password>
# Root password
root_password: <root_password>
# Cloud-init user (i.e. terraform) password
user_password: <user_password>
# Key used by Terraform and Ansible to login to bastion host to execute tasks
ssh_key: |
  -----BEGIN RSA PRIVATE KEY-----
  -----END RSA PRIVATE KEY-----
# Key used by the default Terraform sudo user among all provisioned hosts
terraform_key: |
  -----BEGIN RSA PRIVATE KEY-----
  -----END RSA PRIVATE KEY-----
```

Make sure the bastion host has the terraform user and `terraform_key` authorized with `ssh_key`. Otherwise, use the first gateway host as the bastion host and configure the public IP in your DNS service provider. You also need to ensure the `ssh_key` is your default key in `~/.ssh/id_rsa` or specify the location in the SSH command of `ansible/group_vars/*.yml`.

## Get Started

Provision all the machines using Terraform.

- <https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md>

Complete guide located in the [VM Helper Doc](./docs/VM_helper.md) and [LXC Helper Doc](./docs/LCX_helper.md)

Create a new role for the future terraform user.
Create the user "terraform-prov@pve"
Add the TERRAFORM-PROV role to the terraform-prov user
Create admin-pool and k8s-pool

When making the API Token, should uncheck **Privilege Segregation**

Complete guide located in the [Proxmox Helper Doc](./docs/Proxmox_helper.md)

```bash
# Initialize terraform with the correct environment
make terraform-init ENV=stage

# Plan the terraform action
make terraform-plan ENV=stage

# Apply the terraform configuration
make terraform-apply ENV=stage

# Destroy the terraform configuration (if required)
make terraform-destroy ENV=stage

# Run ansible with a specific tag
make ansible-deploy-with-tag ENV=stage TAG=stage1

# Run the full playbook
make ansible-deploy ENV=stage
```

## References

[Original Repository](https://github.com/dy2k/proxmox-kubernetes)

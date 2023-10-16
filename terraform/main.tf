# terraform {
#   backend "s3" {
#     bucket  = "proxmox-kubernetes"
#     key     = "terraform/terraform.tfstate"
#     region  = "ap-southeast-1"
#     profile = "dy2k"
#     encrypt = true
#   }

#  backend "local" {
#    path = "./backend/terraform.tfstate"
#  }
# }

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = yamldecode(data.local_file.secrets.content).pm_api_url
  pm_user = yamldecode(data.local_file.secrets.content).pm_user
  pm_password = yamldecode(data.local_file.secrets.content).pm_password
  # pm_api_token_id = yamldecode(data.local_file.secrets.content).pm_api_token_id
  # pm_api_token_secret = yamldecode(data.local_file.secrets.content).pm_api_token_secret
  pm_parallel = 1
  pm_debug = true
  pm_log_enable = true
  pm_log_file = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default = "debug"
    _capturelog = ""
  }
}
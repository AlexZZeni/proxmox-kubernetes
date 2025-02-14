# Terraform secrets file
data "local_file" "secrets" {
  filename = "./envs/${var.environment}/.terraform_secret.yaml"
}

data "tls_public_key" "dy2k" {
  private_key_pem = file("./keys/kubernetes/terraform_key")
}

data "tls_public_key" "ubuntu_terraform" {
  private_key_pem = file("./keys/kubernetes/terraform_key")
}

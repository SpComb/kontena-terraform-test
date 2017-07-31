variable "digitalocean-region" {}
variable "digitalocean-size" { }
variable "digitalocean-ssh_key_id" {}
variable "digitalocean-ssh_key_path" {}

variable "kontena-version" {}
variable "kontena-vault_key" {}
variable "kontena-vault_iv" {}
variable "kontena-initial_admin_code" {}

variable "ssl_cert_cn" {
  default = "Test"
}

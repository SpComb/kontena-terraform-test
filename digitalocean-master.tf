variable "digitalocean-master-size" {
  type = "string"
  default = "512mb"
}

module "digitalocean_master" {
  source = "./digitalocean-master"

  digitalocean-region = "${var.digitalocean-region}"
  digitalocean-size = "${var.digitalocean-master-size}"
  digitalocean-ssh_key_id = "${var.digitalocean-ssh_key_id}"
  digitalocean-ssh_key_path = "${var.digitalocean-ssh_key_path}"

  kontena-version = "${var.kontena-version}"
  kontena-vault_key = "${var.kontena-vault_key}"
  kontena-vault_iv = "${var.kontena-vault_iv}"
  kontena-initial_admin_code = "${var.kontena-initial_admin_code}"
}

provider "kontena-oauth2" {
  url = "http://${module.digitalocean_master.ipv4_address}"
}

resource "kontena-oauth2_token" "admin" {
  code = "${var.kontena-initial_admin_code}"
}

provider "kontena" {
  url = "http://${module.digitalocean_master.ipv4_address}"
  token = "${kontena-oauth2_token.admin.token}"
}

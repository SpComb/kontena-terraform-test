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

provider "kontena" {
  alias = "master-bootstrap"
  url = "${module.digitalocean_master.http_url}"
  ssl_cert_pem = "${module.digitalocean_master.ssl_cert_pem}"
  ssl_cert_cn = "${module.digitalocean_master.ssl_cert_cn}"

  // TODO: retry client until master is up? Unless we can use a terraform provisioner to wait for the master to start
}

resource "kontena_token" "admin" {
  provider = "kontena.master-bootstrap"

  code = "${var.kontena-initial_admin_code}"
}

provider "kontena" {
  url = "${module.digitalocean_master.http_url}"
  ssl_cert_pem = "${module.digitalocean_master.ssl_cert_pem}"
  ssl_cert_cn = "${module.digitalocean_master.ssl_cert_cn}"
  token = "${kontena_token.admin.token}"
}

output "KONTENA_URI" {
  value = "${module.digitalocean_master.http_url}"
}

output "KONTENA_TOKEN" {
  value = "${kontena_token.admin.token}"
}

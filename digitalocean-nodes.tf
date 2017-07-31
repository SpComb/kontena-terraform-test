variable "digitalocean-node-size" {
  type = "string"
  default = "1gb"
}

resource "kontena_grid" "grid" {
  name = "${var.kontena-grid}"
  initial_size = "${var.kontena-grid-initial_size}"
  trusted_subnets = [ ]
}

module "digitalocean-node1" {
  source = "./digitalocean-node"

  name = "terraform-test-node1"

  digitalocean-region = "${var.digitalocean-region}"
  digitalocean-size = "${var.digitalocean-node-size}"
  digitalocean-ssh_key_id = "${var.digitalocean-ssh_key_id}"
  digitalocean-ssh_key_path = "${var.digitalocean-ssh_key_path}"

  kontena-version = "${var.kontena-version}"
  kontena-uri = "${module.digitalocean_master.websocket_url}"
  kontena-grid = "${kontena_grid.grid.name}"

  # without SSL verify
}

module "digitalocean-node2" {
  source = "./digitalocean-node"

  name = "terraform-test-node2"

  digitalocean-region = "${var.digitalocean-region}"
  digitalocean-size = "${var.digitalocean-node-size}"
  digitalocean-ssh_key_id = "${var.digitalocean-ssh_key_id}"
  digitalocean-ssh_key_path = "${var.digitalocean-ssh_key_path}"

  kontena-version = "${var.kontena-version}"
  kontena-uri = "${module.digitalocean_master.websocket_url}"
  kontena-grid = "${kontena_grid.grid.name}"

  ssl_cert_pem = "${module.digitalocean_master.ssl_cert_pem}"
  ssl_cert_cn = "${module.digitalocean_master.ssl_cert_cn}"
}

variable "digitalocean-node-size" {
  type = "string"
  default = "1gb"
}

variable "digitalocean-node-count" {
}

module "digitalocean-node" {
  source = "./digitalocean-node"

  count = "${var.digitalocean-node-count}"

  digitalocean-region = "${var.digitalocean-region}"
  digitalocean-size = "${var.digitalocean-node-size}"
  digitalocean-ssh_key_id = "${var.digitalocean-ssh_key_id}"
  digitalocean-ssh_key_path = "${var.digitalocean-ssh_key_path}"

  kontena-version = "${var.kontena-version}"
  kontena-uri = "ws://${module.digitalocean_master.ipv4_address}"
  kontena-grid = "${kontena_grid.grid.name}"
  kontena-grid-token = "${kontena_grid.grid.token}"
}

resource "kontena_node" "node" {
  grid = "${var.kontena-grid}"
  name = "${var.name}"

  labels = [
    "provider=digitalocean",
    "region=${var.digitalocean-region}",
    "az=${var.digitalocean-region}",
  ]
}

module "coreos_node_ignition" {
  source = "../coreos-node-ignition"

  kontena_version = "${var.kontena-version}"
  master_uri = "${var.kontena-uri}"
  grid_token = "${var.kontena-grid-token}"
  node_token = "${kontena_node.node.token}"
  peer_interface = "eth1"

  ssl_cert_pem = "${var.ssl_cert_pem}"
  ssl_cert_cn = "${var.ssl_cert_cn}"
}

resource "digitalocean_droplet" "node" {
  image    = "coreos-stable"
  name     = "${var.name}"
  region   = "${var.digitalocean-region}"
  size     = "${var.digitalocean-size}"
  ssh_keys = [ "${var.digitalocean-ssh_key_id}" ]

  connection {
    type = "ssh"
    user = "core"
    private_key = "${file(var.digitalocean-ssh_key_path)}"
  }

  user_data = "${module.coreos_node_ignition.user_data}"
}

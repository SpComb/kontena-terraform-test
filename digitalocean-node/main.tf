module "coreos_node_ignition" {
  source = "../coreos-node-ignition"
  kontena_version = "${var.kontena-version}"
  master_uri = "${var.kontena-uri}"
  grid_token = "${var.kontena-grid-token}"
  peer_interface = "eth1"
}

resource "digitalocean_droplet" "node" {
  count = "${var.count}"

  image    = "coreos-stable"
  name     = "terraform-test-node${count.index + 1}"
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

resource "kontena_node" "node" {
  count = "${var.count}"
  depends_on = [
    "digitalocean_droplet.node",
  ]

  grid = "${var.kontena-grid}"
  name = "terraform-test-node${count.index + 1}"

  labels = [
    "provider=digitalocean",
    "region=${digitalocean_droplet.node.*.region[count.index]}",
    "az=${digitalocean_droplet.node.*.region[count.index]}",
  ]
}

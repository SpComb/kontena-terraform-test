variable "digitalocean_node_count" {
  type = "string"
  default = 1
}
variable "digitalocean_node_region" {
  type = "string"
}
variable "digitalocean_node_size" {
  type = "string"
  default = "1gb"
}


module "kontena_node" {
  source = "./kontena-node"
  kontena_version = "${var.kontena-version}"
  master_uri = "ws://${digitalocean_droplet.master.ipv4_address}:80"
  grid_token = "${kontena_grid.grid.token}"
  peer_interface = "eth1"
}

resource "digitalocean_droplet" "node" {
  count = "${var.digitalocean_node_count}"

  image    = "coreos-stable"
  name     = "terraform-test-node${count.index + 1}"
  region   = "${var.digitalocean_node_region}"
  size     = "${var.digitalocean_node_size}"
  ssh_keys = [ "${var.do_ssh_key_id}" ]

  connection {
    type = "ssh"
    user = "core"
    private_key = "${file(var.do_ssh_key_path)}"
  }

  user_data = "${module.kontena_node.user_data}"
}

variable "digitalocean_master_region" {
  type = "string"
}
variable "digitalocean_master_size" {
  type = "string"
  default = "512mb"
}


module "kontena_master" {
  source = "./kontena-master"
  kontena_version = "${var.kontena-version}"
  vault_key = "${var.kontena-vault_key}"
  vault_iv = "${var.kontena-vault_iv}"
  initial_admin_code = "${var.kontena-initial_admin_code}"
}

resource "digitalocean_droplet" "master" {
  image    = "coreos-stable"
  name     = "terraform-test-master"
  region   = "${var.digitalocean_master_region}"
  size     = "${var.digitalocean_master_size}"
  ssh_keys = [ "${var.do_ssh_key_id}" ]

  connection {
    type = "ssh"
    user = "core"
    private_key = "${file(var.do_ssh_key_path)}"
  }

  user_data = "${module.kontena_master.user_data}"
}

resource "kontena_grid" "grid" {
  name = "${var.kontena_grid}"
  initial_size = "${var.kontena_grid-initial_size}"
  trusted_subnets = [ ]
}

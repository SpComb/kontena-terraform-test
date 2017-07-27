module "coreos_master_ignition" {
  source = "../coreos-master-ignition"
  kontena_version = "${var.kontena-version}"
  vault_key = "${var.kontena-vault_key}"
  vault_iv = "${var.kontena-vault_iv}"
  initial_admin_code = "${var.kontena-initial_admin_code}"
}

resource "digitalocean_droplet" "master" {
  image    = "coreos-stable"
  name     = "terraform-test-master"
  region   = "${var.digitalocean-region}"
  size     = "${var.digitalocean-size}"
  ssh_keys = [ "${var.digitalocean-ssh_key_id}" ]

  connection {
    type = "ssh"
    user = "core"
    private_key = "${file(var.digitalocean-ssh_key_path)}"
  }

  user_data = "${module.coreos_master_ignition.user_data}"
}

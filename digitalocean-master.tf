variable "kontena-version" {
  type = "string"
  default = "1.3.0"
}
variable "kontena-vault_key" {
  type = "string"
}
variable "kontena-vault_iv" {
  type = "string"
}
variable "kontena-initial_admin_code" {
  type = "string"
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
  region   = "fra1"
  size     = "512mb"
  ssh_keys = [ "${var.do_ssh_key_id}" ]

  connection {
    type = "ssh"
    user = "core"
    private_key = "${file(var.do_ssh_key_path)}"
  }

  user_data = "${module.kontena_master.user_data}"
}

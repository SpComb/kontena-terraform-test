variable "do_token" {
  type = "string"
}

variable "do_ssh_key_path" {
  type = "string"
  default = "~/.ssh/id_rsa"
}
variable "do_ssh_key_id" {
  type = "string"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

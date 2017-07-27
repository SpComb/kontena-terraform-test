variable "digitalocean-token" {
  type = "string"
}
variable "digitalocean-region" {
  type = "string"
}

variable "digitalocean-ssh_key_path" {
  type = "string"
  default = "~/.ssh/id_rsa"
}
variable "digitalocean-ssh_key_id" {
  type = "string"
}

provider "digitalocean" {
  token = "${var.digitalocean-token}"
}

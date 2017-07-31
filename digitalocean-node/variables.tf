variable "name" {}

variable "digitalocean-region" {}
variable "digitalocean-size" {}
variable "digitalocean-ssh_key_id" {}
variable "digitalocean-ssh_key_path" {}

variable "kontena-version" {}
variable "kontena-uri" {}
variable "kontena-grid" {}
variable "kontena-grid-token" {
  default = ""
}

variable "ssl_cert_pem" { default = "" }
variable "ssl_cert_cn" { default = "" }

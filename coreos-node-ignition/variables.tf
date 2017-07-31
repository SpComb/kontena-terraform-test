variable "kontena_version" {}
variable "master_uri" {}
variable "grid_token" {
  default = ""
}
variable "node_token" {
  default = ""
}
variable "peer_interface" {}

variable "ssl_cert_pem" { default = "" }
variable "ssl_cert_cn" { default = "" }

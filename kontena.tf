variable "kontena-version" {
  type = "string"
  default = "1.4.0.pre5"
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
variable "kontena-access_token" {
  type = "string"
}

variable "kontena-grid" {
  type = "string"
  default = "test"
}
variable "kontena-grid-initial_size" {
  default = 1
}

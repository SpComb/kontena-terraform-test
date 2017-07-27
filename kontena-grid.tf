resource "kontena_grid" "grid" {
  name = "${var.kontena-grid}"
  initial_size = "${var.kontena-grid-initial_size}"
  trusted_subnets = [ ]
}

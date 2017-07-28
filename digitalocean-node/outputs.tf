output "ipv4_address" {
  value = "${digitalocean_droplet.node.ipv4_address}"
}

// XXX: only on second apply, after droplet is up and the kontena_node refreshes
output "node_id" {
  value = "${kontena_node.node.node_id}"
}

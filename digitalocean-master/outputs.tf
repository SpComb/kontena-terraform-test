output "http_url" {
  value = "http://${digitalocean_droplet.master.ipv4_address}:80"
}
output "websocket_url" {
  value = "ws://${digitalocean_droplet.master.ipv4_address}:80"
}

output "http_url" {
  value = "https://${digitalocean_droplet.master.ipv4_address}"
}
output "websocket_url" {
  value = "wss://${digitalocean_droplet.master.ipv4_address}"
}
output "ssl_cert_pem" {
  value = "${tls_self_signed_cert.master.cert_pem}"
}
output "ssl_cert_cn" {
  value = "${var.ssl_cert_cn}"
}

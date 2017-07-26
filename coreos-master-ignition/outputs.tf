output "user_data" {
  value = "${data.ignition_config.kontena-master.rendered}"
}

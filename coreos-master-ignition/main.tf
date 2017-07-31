data "template_file" "kontena-server_env" {
  template = "${file("${path.module}/templates/kontena-server.env")}"

  vars {
    kontena_version = "${var.kontena_version}"
    vault_key = "${var.vault_key}"
    vault_iv = "${var.vault_iv}"
    initial_admin_code = "${var.initial_admin_code}"
    ssl_cert = "${var.ssl_cert != "" && var.ssl_key != "" ? "/etc/kontena-server.pem" : ""}"
  }
}

data "template_file" "kontena-server_pem" {
  template = "${file("${path.module}/templates/kontena-server.pem")}"

  vars {
    ssl_cert = "${var.ssl_cert}"
    ssl_key = "${var.ssl_key}"
  }
}

data "ignition_file" "kontena-server_env" {
  filesystem = "root"
  path = "/etc/kontena-server.env"
  content {
    content = "${data.template_file.kontena-server_env.rendered}"
  }
}
data "ignition_file" "kontena-server_pem" {
  filesystem = "root"
  path = "/etc/kontena-server.pem"
  content {
    content = "${data.template_file.kontena-server_pem.rendered}"
  }
}

data "ignition_systemd_unit" "kontena-server-mongo" {
  name = "kontena-server-mongo.service"
  content = "${file("${path.module}/files/kontena-server-mongo.service")}"
}
data "ignition_systemd_unit" "kontena-server-api" {
  name = "kontena-server-api.service"
  content = "${file("${path.module}/files/kontena-server-api.service")}"
}
data "ignition_systemd_unit" "kontena-server-haproxy" {
  name = "kontena-server-haproxy.service"
  content = "${file("${path.module}/files/kontena-server-haproxy.service")}"
}
data "ignition_file" "kontena-server-haproxy_sh" {
  filesystem = "root"
  path = "/opt/bin/kontena-server-haproxy.sh"
  mode = "0755"
  content {
    content = "${file("${path.module}/files/kontena-server-haproxy.sh")}"
  }
}

data "ignition_config" "kontena-master" {
  files = [
    "${data.ignition_file.kontena-server_env.id}",
    "${data.ignition_file.kontena-server_pem.id}",
    "${data.ignition_file.kontena-server-haproxy_sh.id}",
  ]
  systemd = [
    "${data.ignition_systemd_unit.kontena-server-mongo.id}",
    "${data.ignition_systemd_unit.kontena-server-api.id}",
    "${data.ignition_systemd_unit.kontena-server-haproxy.id}",
  ]
}

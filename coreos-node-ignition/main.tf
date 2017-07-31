data "template_file" "kontena-agent_env" {
  template = "${file("${path.module}/templates/kontena-agent.env")}"

  vars {
    kontena_version = "${var.kontena_version}"
    kontena_uri = "${var.master_uri}"
    kontena_token = "${var.node_token == "" ? var.grid_token : ""}" // XXX: empty token needs to omitted from template
    kontena_node_token = "${var.node_token}"
    kontena_peer_interface = "${var.peer_interface}"
    ssl_cert_file = "${var.ssl_cert_pem == "" ? "" : "/etc/kontena-agent/ca.pem"}"
    kontena_ssl_verify = "${var.ssl_cert_pem != ""}"
    kontena_ssl_hostname = "${var.ssl_cert_cn}"
  }
}
data "template_file" "kontena-cert_pem" {
  template = "${file("${path.module}/templates/kontena-cert.pem")}"

  vars {
    ssl_cert = "${var.ssl_cert_pem}"
  }
}

data "ignition_file" "kontena-agent-ca_pem" {
  filesystem = "root"
  path = "/etc/kontena-agent/ca.pem"
  mode = "0644"
  content {
    content = "${data.template_file.kontena-cert_pem.rendered}"
  }
}
data "ignition_file" "kontena-agent_env" {
  filesystem = "root"
  path = "/etc/kontena-agent.env"
  content {
    content = "${data.template_file.kontena-agent_env.rendered}"
  }
}

data "ignition_systemd_unit" "kontena-agent" {
  name = "kontena-agent.service"
  content = "${file("${path.module}/files/kontena-agent.service")}"
}

data "ignition_networkd_unit" "weave" {
  name = "50-weave.network"
  content = "${file("${path.module}/files/50-weave.network")}"
}

data "ignition_config" "kontena-node" {
  files = [
    "${data.ignition_file.kontena-agent-ca_pem.id}",
    "${data.ignition_file.kontena-agent_env.id}",
  ]
  networkd = [
    "${data.ignition_networkd_unit.weave.id}",
  ]
  systemd = [
    "${data.ignition_systemd_unit.kontena-agent.id}",
  ]
}

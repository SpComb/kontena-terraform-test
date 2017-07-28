data "template_file" "kontena-agent_env" {
  template = "${file("${path.module}/templates/kontena-agent.env")}"

  vars {
    kontena_version = "${var.kontena_version}"
    kontena_uri = "${var.master_uri}"
    kontena_token = "${var.node_token == "" ? var.grid_token : ""}" // XXX: empty token needs to omitted from template
    kontena_node_token = "${var.node_token}"
    kontena_peer_interface = "${var.peer_interface}"
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
    "${data.ignition_file.kontena-agent_env.id}",
  ]
  networkd = [
    "${data.ignition_networkd_unit.weave.id}",
  ]
  systemd = [
    "${data.ignition_systemd_unit.kontena-agent.id}",
  ]
}

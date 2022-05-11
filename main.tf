resource "null_resource" "install_zabbix_agent" {
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.user
      private_key = var.private_key
      host = var.host
    }
    inline = [
      "sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+ubuntu20.04_all.deb",
      "sudo dpkg -i zabbix-release_6.0-1+ubuntu20.04_all.deb",
      "sudo apt-get update -y",
      "sudo apt-get install -y zabbix-agent"
    ]
  }
}
resource "null_resource" "update_zabbix_agentd_conf" {
  provisioner "local-exec" {
    command = "echo Server=${var.zabbix_server_ip} >> zabbix_agentd.conf && echo Server=${var.zabbix_server_hostname} >> zabbix_agentd.conf"
  }
}
resource "null_resource" "copy_zabbix_agentd_conf" {
  depends_on = [
    null_resource.install_zabbix_agent,
    null_resource.update_zabbix_agentd_conf
  ]
  provisioner "file" {
    connection {
      type = "ssh"
      user = var.user
      private_key = var.private_key
      host = var.host
    }
    source = "zabbix_agentd.conf"
    destination = "~/zabbix_agentd.conf"
  }
}
resource "null_resource" "start_zabbix_agent" {
  depends_on = [
    null_resource.copy_zabbix_agentd_conf
  ]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.user
      private_key = var.private_key
      host = var.host
    }
    inline = [
      "sudo cp ~/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf",
      "sudo systemctl restart zabbix-agent",
      "sudo systemctl enable zabbix-agent"
    ]
  }
}

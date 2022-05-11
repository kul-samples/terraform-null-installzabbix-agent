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

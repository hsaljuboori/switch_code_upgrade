
provider "null" {}

variable "switch_ips" {
  type    = list(string)
  default = ["192.168.86.28", "192.168.86.135"] 
}

resource "null_resource" "upgrade_switch" {
  count = length(var.switch_ips)

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i ${element(var.switch_ips, count.index)}, upgrade_switch.yml
    EOT
  }
}


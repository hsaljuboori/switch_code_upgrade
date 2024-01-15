
provider "null" {}

variable "switch_ips" {
  type    = list(string)
  default = ["10.18.1.1", "10.18.1.2", "10.18.1.3"] 
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


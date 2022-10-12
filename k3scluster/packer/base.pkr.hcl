variable "login" {
  type    = string
  default = "root"
}

variable "password" {
  type    = string
  default = "${env("ROOT_PASSWORD")}"
}

variable "sshkey" {
  type    = string
  default = "${env("SSH_PUB_KEY")}"
}

source "qemu" "debian11" {
  accelerator       = "kvm"
  boot_command      = ["<down><down><enter><down><down><down><down><down><down><tab>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian11.txt.password ", "auto-install/enable=true ", "DEBCONF_DEBUG=5", "<enter>"]
  boot_key_interval = "10ms"
  boot_wait         = "5s"
  disk_interface    = "virtio"
  disk_size         = "30720M"
  format            = "qcow2"
  http_directory    = "./preseed/"
  #  iso_checksum      = "e307d0e583b4a8f7e5b436f8413d4707dd4242b70aea61eb08591dc0378522f3"
  iso_checksum = "file:https://mirrors.ustc.edu.cn/debian-cd/current/amd64/iso-cd/SHA256SUMS"
  iso_url      = "/data/ISOandIMAGES/debian-11.5.0-amd64-netinst.iso"
  #  iso_url           = "https://mirrors.ustc.edu.cn/debian-cd/current/amd64/iso-cd/debian-11.5.0-amd64-netinst.iso"
  memory           = 1024
  net_device       = "virtio-net"
  output_directory = "output"
  qemuargs         = [["-display", "none"], ["-cpu", "host"]]
  shutdown_command = "shutdown -P now"
  ssh_password     = "${var.password}"
  ssh_timeout      = "60m"
  ssh_username     = "${var.login}"
  vm_name          = "debian11"
}

build {
  sources = ["source.qemu.debian11"]

  provisioner "shell" {
    inline = [
      "mkdir /root/.ssh",
      "echo \"${var.sshkey}\" > /root/.ssh/authorized_keys",
      "chmod 0600 /root/.ssh/authorized_keys",
      "echo 'WantedBy=dev-virtio\\x2dports-org.qemu.guest_agent.0.device' >> /lib/systemd/system/qemu-guest-agent.service",
      "systemctl daemon-reload",
      "systemctl enable qemu-guest-agent.service"
    ]
  }

}


variable "vms" {
  type    = list(any)
  default = []
}

variable "subnet" {
  type    = string
  default = "192.168.123.0/24"
}

variable "net_name" {
  type    = string
  default = "k3snet"
}

variable "net_domain" {
  type    = string
  default = "k3s.local"
}

variable "user" {
  type    = string
  default = "root"
}

variable "ssh_key" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "templates_pool" {
  type    = string
  default = "templates"
}

variable "template_img" {
  type    = string
  default = "debian11-5.qcow2"
}


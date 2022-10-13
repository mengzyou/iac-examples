terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
  }
  required_version = ">= 0.13"
}

provider "libvirt" {
  uri = var.libvirt_uri
}

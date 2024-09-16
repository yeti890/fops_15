terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.129.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = "= 1.9.5"
}

provider "yandex" {
#  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

provider "docker" {
  host = "ssh://ubuntu@${data.terraform_remote_state.docker.outputs.mysql_vm_ip}"
  ssh_opts = ["-o", "StrictHostKeyChecking=no"]
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  cloud_id = "b1g2m7havcskm9i262p9"
  folder_id = "b1goi2cu240f4kh657f9" 
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  zone = "ru-central1-b"
}

### Instances
resource "yandex_compute_instance" "vm-1" {
  name = "terraform-nginx"
  hostname = "ngx"
  platform_id = "standard-v2"

  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8go38kje4f6v3g2k4q"
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-ngx.id
    nat       = true
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

}

### Networks
resource "yandex_vpc_network" "ngxnet" {
  name = "network-ngx"
}

resource "yandex_vpc_subnet" "subnet-ngx" {
  name           = "subnet-ngx"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.ngxnet.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

### Outputs
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

# external=$(terraform output -raw external_ip_address_vm_1)
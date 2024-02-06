terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.107.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  cloud_id  = "b1g2m7havcskm9i262p9"
  folder_id = "b1goi2cu240f4kh657f9"
  zone_id   = "ru-central1-a"
}

provider "yandex" {
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.zone_id
}

### CREATE NETWORK
resource "yandex_vpc_network" "network-ngx" {
  name = "network-ngx"
}

resource "yandex_vpc_subnet" "subnet-ngx" {
  name           = "subnet-ngx"
  zone           = local.zone_id
  network_id     = yandex_vpc_network.network-ngx.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

### CREATE INSTANCES
resource "yandex_compute_instance" "vm-ngx" {
  count       = 2
  name        = "vm-ngx-${count.index}"
  hostname    = "ngx-${count.index}"
  platform_id = "standard-v2"

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 1
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8lmueoqum660atdd5r"
      size     = 13
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-ngx.id
    nat       = true
  }

  metadata = {
    user-data = "${file("cloud-init.yaml")}"
  }

}

### CREATE TARGET GROUP
resource "yandex_lb_target_group" "ngx-group" {
  name      = "nginx-target-group"
  folder_id = local.folder_id

  dynamic "target" {
    for_each = [for s in yandex_compute_instance.vm-ngx : {
      address   = s.network_interface.0.ip_address
      subnet_id = s.network_interface.0.subnet_id
    }]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lb-ngx" {
  name = "loadbalancer"
  type = "external"

  listener {
    name        = "listener"
    port        = 80
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.ngx-group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "loadbalancer_ip_address" {
  value = yandex_lb_network_load_balancer.lb-ngx.listener.*.external_address_spec[0].*.address
}

# Output values
output "public-ip-address-for" {
  description = "Public IP address"
  value       = yandex_compute_instance.vm-ngx[*].network_interface.0.nat_ip_address
}

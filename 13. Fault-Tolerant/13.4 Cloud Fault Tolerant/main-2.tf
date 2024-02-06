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

### CREATE INSTANCES GROUP
resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}

resource "yandex_compute_instance_group" "ig-ngx" {
  name                = "igroup-ngx"
  folder_id           = local.folder_id
  service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  deletion_protection = "true"
  instance_template {
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
      network_id         = "${yandex_vpc_network.network-ngx.id}"
      subnet_ids         = ["${yandex_vpc_subnet.subnet-ngx.id}"]
    }

    metadata = {
        user-data = "${file("cloud-init.yaml")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "tg-ngx"
    target_group_description = "load balancer target group"
  }
}

resource "yandex_lb_network_load_balancer" "lb-ngx" {
  name = "nlb-ngx"

  listener {
    name = "listen-ngx"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-ngx.load_balancer.0.tg-ngx_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}

### OUTPUT
output "loadbalancer_ip_address" {
  value = yandex_lb_network_load_balancer.lb-ngx.listener.*.external_address_spec[0].*.address
}

output "public-ip-address-for" {
  description = "Public IP address"
  value       = yandex_compute_instance_group.ig-ngx[*].network_interface.0.nat_ip_address
}
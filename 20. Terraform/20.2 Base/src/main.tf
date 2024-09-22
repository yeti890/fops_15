### VPC network

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}


### WEB resource

resource "yandex_vpc_subnet" "web_subnet" {
  name           = var.vm_web_vpc_name
  zone           = var.vm_web_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_web_default_cidr
}

data "yandex_compute_image" "web_image" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "web_platform" {
# name        = var.vm_web_name
  name        = local.vm_web_name_geo
  platform_id = var.vm_web_platform_id
  zone        = var.vm_web_zone
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web_image.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.web_subnet.id
    nat       = true
  }

  metadata = var.metadata

}


### DB resource

resource "yandex_vpc_subnet" "db_subnet" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_default_cidr
}

data "yandex_compute_image" "db_image" {
  family = var.vm_db_image_family
}

resource "yandex_compute_instance" "db_platform" {
# name        = var.vm_db_name
  name        = local.vm_db_name_geo
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_image.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db_subnet.id
    nat       = true
  }

  metadata = var.metadata

}
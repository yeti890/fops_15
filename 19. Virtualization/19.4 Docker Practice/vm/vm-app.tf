resource "yandex_compute_instance" "app" {
  name        = var.vm_resources.app.name
  hostname    = var.vm_resources.app.name
  platform_id = var.vm_platform_id
  
  resources {
    cores         = var.vm_resources.app.cores
    memory        = var.vm_resources.app.memory
    core_fraction = var.vm_resources.app.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [ yandex_vpc_security_group.example.id ]
  }

  metadata = local.metadata

}
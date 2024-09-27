resource "yandex_compute_disk" "disk_vm" {
  name       = "${var.disk_resources.disk.name}${count.index + 1}"
  type       = var.disk_resources.disk.type
  size       = var.disk_resources.disk.size
  count      = var.disk_resources.disk.count
}

resource "yandex_compute_instance" "storage" {
  name        = "${var.vm_resources.storage.name}-${count.index + 1}"
  hostname    = "${var.vm_resources.storage.name}-${count.index + 1}"
  platform_id = var.vm_platform_id
  count       = var.vm_resources.storage.count
  
  depends_on = [ yandex_compute_disk.disk_vm ]

  resources {
    cores         = var.vm_resources.storage.cores
    memory        = var.vm_resources.storage.memory
    core_fraction = var.vm_resources.storage.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk_vm
      content {
        disk_id = secondary_disk.value.id
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
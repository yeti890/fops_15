resource "yandex_compute_instance" "count_vm" {
  name        = "${var.vm_resources.web.name}-${count.index + 1}"
  hostname    = "${var.vm_resources.web.name}-${count.index + 1}"
  platform_id = var.vm_platform_id
  count       = var.vm_resources.web.count
  depends_on  = [ yandex_compute_instance.for_each-vm ]

  resources {
    cores         = var.vm_resources.web.cores
    memory        = var.vm_resources.web.memory
    core_fraction = var.vm_resources.web.core_fraction
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
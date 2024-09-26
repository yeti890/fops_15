resource "yandex_compute_instance" "for_each-vm" {
  for_each    = { for db in var.each_vm : db.vm_name => db }
  name        = each.value.vm_name
  hostname    = each.value.vm_name
  platform_id = var.vm_platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_image.image_id
      size     = each.value.disk_volume
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
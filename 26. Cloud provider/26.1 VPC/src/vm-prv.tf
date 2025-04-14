resource "yandex_compute_instance" "private_instance" {
  name              = var.vm_resources.private.name
  platform_id       = var.vm_platform_id
  zone              = var.subnets.private.zone
  resources {
    cores           = var.vm_resources.private.cores
    memory          = var.vm_resources.private.memory
    core_fraction   = var.vm_resources.private.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id      = data.yandex_compute_image.vm_image.id
    }
  }

  scheduling_policy {
    preemptible     = true
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.private_subnet.id
  }

  metadata = {
    ssh-keys        = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
resource "yandex_compute_instance" "public_instance" {
  name              = var.vm_resources.public.name
  platform_id       = var.vm_platform_id
  zone              = var.subnets.public.zone
  resources {
    cores           = var.vm_resources.public.cores
    memory          = var.vm_resources.public.memory
    core_fraction   = var.vm_resources.public.core_fraction
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
    subnet_id       = yandex_vpc_subnet.public_subnet.id
    nat             = true
  }

  metadata = {
    ssh-keys        = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
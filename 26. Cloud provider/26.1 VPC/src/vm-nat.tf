resource "yandex_compute_instance" "nat_instance" {
  name              = var.vm_resources.nat.name
  platform_id       = var.vm_platform_id
  zone              = var.subnets.public.zone
  resources {
    cores           = var.vm_resources.nat.cores
    memory          = var.vm_resources.nat.memory
    core_fraction   = var.vm_resources.nat.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id      = var.vm_resources.nat.image_id
    }
  }

  scheduling_policy {
    preemptible     = true
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.public_subnet.id
    ip_address      = var.vm_resources.nat.int_ip
    nat             = true
  }

  metadata = {
    ssh-keys        = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
data "yandex_compute_image" "ubuntu-22-04" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "mysql-1" {

  name        = "mysql-1"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      size     = 20
      type     = "network-ssd"
      image_id = data.yandex_compute_image.ubuntu-22-04.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    # ssh-keys  = "ubuntu:${file(var.public_key_path)}"
    user-data = file("cloud-init.yml")
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Default VM settings
vm_platform_id    = "standard-v2"
vm_image_family   = "ubuntu-2004-lts"

# Resources
vm_resources = {
  lamp = {
    name          = "lamp-vm"
    cores         = 2
    memory        = 2
    core_fraction = 20
    image_id      = "fd827b91d99psvq5fjit"
    int_ip        = "192.168.10.254"
  }
}

# Network
subnets = {
  public = {
    name          = "public"
    zone          = "ru-central1-a"
    cidr          = "192.168.10.0/24"
  }
}


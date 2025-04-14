# Default VM settings
vm_platform_id    = "standard-v2"
vm_image_family   = "ubuntu-2004-lts"

# Resources
vm_resources = {
  nat = {
    name          = "nat-vm"
    cores         = 2
    memory        = 2
    core_fraction = 5
    image_id      = "fd80mrhj8fl2oe87o4e1"
    int_ip        = "192.168.10.254"
  }
  public = {
    name          = "pub-vm"
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  private = {
    name          = "prv-vm"
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
}

# Network
subnets = {
  public = {
    name          = "public"
    zone          = "ru-central1-a"
    cidr          = "192.168.10.0/24"
  }
  private = { 
    name          = "private"
    zone          = "ru-central1-a"
    cidr          = "192.168.20.0/24"
  }
}

routes = [
  {
    route_name    = "nat-instance"
    route_dest    = "0.0.0.0/0"
  }
]

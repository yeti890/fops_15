# Default VM settings
vm_platform_id  = "standard-v2"
vm_image_family = "ubuntu-2004-lts"

# Resources
vm_resources = {
  web = {
    name          = "web"
    cores         = 2
    memory        = 1
    core_fraction = 5
    count         = 2
  }
  storage = {
    name          = "storage"
    cores         = 2
    memory        = 2
    core_fraction = 5
    count         = 1
  }
}

disk_resources = {
  "disk" = {
    name          = "disk"
    type          = "network-hdd"
    size          = 1
    count         = 3
  }
}

each_vm = [
  { 
    vm_name     = "main"
    cpu         = 4
    ram         = 4
    disk_volume = 15
    fraction    = 5
  },
  { vm_name     = "replica"
    cpu         = 2
    ram         = 2
    disk_volume = 10
    fraction    = 5
  }
]




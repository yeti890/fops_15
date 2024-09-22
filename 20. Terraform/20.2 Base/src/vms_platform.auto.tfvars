# VPC network
vpc_name            = "develop"

# WEB resources
vm_web_vpc_name     = "web_subnet"
vm_web_default_cidr = ["10.0.1.0/24"]
vm_web_default_zone = "ru-central1-a"

vm_web_zone         = "ru-central1-a"
vm_web_platform_id  = "standard-v2"
vm_web_image_family = "ubuntu-2004-lts"
vm_web_name         = "netology-develop-platform-web"

# DB resources
vm_db_vpc_name      = "db_subnet"
vm_db_default_cidr  = ["10.0.2.0/24"]
vm_db_default_zone  = "ru-central1-b"

vm_db_zone          = "ru-central1-b"
vm_db_platform_id   = "standard-v2"
vm_db_image_family  = "ubuntu-2004-lts"
vm_db_name          = "netology-develop-platform-db"

# VMS resources
vms_resources = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
}

# SSH metadata
metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqzD7fzMME4hpcYuL5S4dHwjbvbtHLht0cpIOa+/wRf"
}
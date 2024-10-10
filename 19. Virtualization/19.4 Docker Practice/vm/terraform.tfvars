# Default VM settings
vm_platform_id  = "standard-v2"
vm_image_family = "debian-12"

# Resources
vm_resources = {
  app = {
    name          = "app"
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}
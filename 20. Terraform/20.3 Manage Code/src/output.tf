output "webservers" {
  value = [
    for instance in yandex_compute_instance.count_vm : {
      name        = instance.name
      external_ip = instance.network_interface[0].nat_ip_address
      fqdn        = instance.fqdn
    }
  ]
}

output "databases" {
  value = [
    for instance in yandex_compute_instance.for_each-vm : {
      name        = instance.name
      external_ip = instance.network_interface[0].nat_ip_address
      fqdn        = instance.fqdn
    }
  ]
}

output "storage" {
  value = {
    name            = yandex_compute_instance.storage.name
    external_ip     = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    fqdn            = yandex_compute_instance.storage.fqdn
  }
}

output "webservers" {
  value = [
    for web in yandex_compute_instance.count_vm : {
      name        = web.name
      external_ip = i.network_interface[0].nat_ip_address
      fqdn        = i.fqdn
    }
  ]
}

output "databases" {
  value = [
    for i in yandex_compute_instance.for_each-vm : {
      name        = i.name
      external_ip = i.network_interface[0].nat_ip_address
      fqdn        = i.fqdn
    }
  ]
}

output "storage" {
  value = [
    for i in yandex_compute_instance.storage : {
      name        = i.name
      external_ip = i.network_interface[0].nat_ip_address
      fqdn        = i.fqdn
    }
  ]
}

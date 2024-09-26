resource "local_file" "hosts" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = [for instance in yandex_compute_instance.count_vm : {
        name            = instance.name
        nat_ip_address  = instance.network_interface[0].nat_ip_address
        fqdn            = instance.fqdn
      }]
      databases = [for instance in yandex_compute_instance.for_each-vm : {
        name            = instance.name
        nat_ip_address  = instance.network_interface[0].nat_ip_address
        fqdn            = instance.fqdn
      }]
      storage = [{
        name            = yandex_compute_instance.storage.name
        nat_ip_address  = yandex_compute_instance.storage.network_interface[0].nat_ip_address
        fqdn            = yandex_compute_instance.storage.fqdn
      }]
    }
  )
  filename = "${path.module}/hosts"
}

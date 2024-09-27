resource "local_file" "hosts" {
  content = templatefile("${path.module}/hosts.tftpl",
  { 
    webservers = yandex_compute_instance.count_vm
    databases = yandex_compute_instance.for_each-vm
    storage = yandex_compute_instance.storage
  } )
  filename = "${path.module}/hosts"
}

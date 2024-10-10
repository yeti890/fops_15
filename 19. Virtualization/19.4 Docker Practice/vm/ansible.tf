resource "local_file" "hosts" {
  content = templatefile("${path.module}/hosts.tftpl",
  { 
    app =  [ yandex_compute_instance.app ]
  } )
  filename = "${path.module}/hosts"
}

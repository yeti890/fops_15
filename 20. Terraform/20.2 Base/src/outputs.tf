output "web_instance_info" {
  description = "WEB instance info"
  value       = { 
    instance_name   = yandex_compute_instance.web_platform.name
    external_ip     = yandex_compute_instance.web_platform.network_interface[0].nat_ip_address
    fqdn            = yandex_compute_instance.web_platform.fqdn
  }
}

output "db_instance_info" {
  description = "DB instance info"
  value       = { 
    instance_name   = yandex_compute_instance.db_platform.name
    external_ip     = yandex_compute_instance.db_platform.network_interface[0].nat_ip_address
    fqdn            = yandex_compute_instance.db_platform.fqdn
  }
}
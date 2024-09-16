# Output values
output "mysql_vm_ip" {
  description = "mysql_vm_ip"
  value       = yandex_compute_instance.mysql-1.network_interface.0.nat_ip_address
}
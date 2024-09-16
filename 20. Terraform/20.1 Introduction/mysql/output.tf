# Output values
output "mysql_root_password" {
  value = random_password.mysql_root_password.result
  sensitive = true
}

output "mysql_password" {
  value = random_password.mysql_password.result
  sensitive = true
}
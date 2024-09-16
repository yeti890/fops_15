data "terraform_remote_state" "docker" {
  backend = "local"

  config = {
    path = "${path.module}/../docker/terraform.tfstate"
  }
}

resource "random_password" "mysql_root_password" {
  length  = 16
  special = true
}

resource "random_password" "mysql_password" {
  length  = 16
  special = true
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql-8" {
  name  = "mysql-8"
  image = docker_image.mysql.image_id
  
  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}
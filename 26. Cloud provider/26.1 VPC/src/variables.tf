### cloud vars
variable "token" {
  type            = string
  description     = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type            = string
  description     = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type            = string
  description     = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type            = string
  default         = "ru-central1-a"
  description     = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type            = list(string)
  default         = ["10.0.1.0/24"]
  description     = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type            = string
  default         = "develop"
  description     = "VPC network&subnet name"
}

### resource vars
variable vm_platform_id {
  type            = string
  default         = "standard-v2"
  description     = "Yandex compute VM platform id"
}

variable vm_image_family {
  type            = string
  default         = "ubuntu-2004-lts"
  description     = "Yandex compute VM family image"
}

variable "vm_resources" {
  type = map(object({
    name          = string
    cores         = number
    memory        = number
    core_fraction = number
    count         = optional(number)
    image_id      = optional(string)
    int_ip        = optional(string)
  }))
}

variable "subnets" {
  type = map(object({
    name          = string
    zone          = string
    cidr          = string
  }))
}

variable "routes" {
  type = list(object({
    route_name    = string
    route_dest    = string
    route_hop     = optional(string)
  }))
  default = [
  {
    route_name    = "default"
    route_dest    = "0.0.0.0/0"
    route_hop     = ""
  }]
}
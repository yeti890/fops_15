###cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}




###network vars

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}

variable "vm_web_vpc_name" {
  type        = string
  default     = "web"
  description = "VPC WEB subnet name"
}

variable "vm_web_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_web_default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "database"
  description = "VPC DB subnet name"
}

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}





###ssh vars

variable "metadata" {
  type = map(string)
  description = "Default metadata for VM"
}

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqzD7fzMME4hpcYuL5S4dHwjbvbtHLht0cpIOa+/wRf"
#  description = "ssh-keygen -t ed25519"
#}





###resource vars

variable vm_web_zone {
  type        = string
  default     = "ru-central1-a"
  description = "Yandex compute WEB zone for resources"
}

variable vm_web_platform_id {
  type        = string
  default     = "standard-v2"
  description = "Yandex compute WEB platform id for resources"
}

variable vm_web_image_family {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute WEB family image"
}

variable vm_web_name {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Yandex compute WEB instance name"
}

variable vm_db_zone {
  type        = string
  default     = "ru-central1-b"
  description = "Yandex compute DB zone for resources"
}

variable vm_db_platform_id {
  type        = string
  default     = "standard-v2"
  description = "Yandex compute DB platform id for resources"
}

variable vm_db_image_family {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute DB family image"
}

variable vm_db_name {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Yandex compute DB instance name"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
}

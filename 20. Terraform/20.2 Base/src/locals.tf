locals {
  vm_web_name_geo = "${var.vm_web_name}-${var.vm_web_zone}"
  vm_db_name_geo  = "${var.vm_db_name}-${var.vm_db_zone}"
}
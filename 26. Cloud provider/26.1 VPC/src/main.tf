resource "yandex_vpc_network" "develop" {
  name            = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  name            = var.subnets.public.name
  zone            = var.subnets.public.zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = [var.subnets.public.cidr]
}

resource "yandex_vpc_subnet" "private_subnet" {
  name            = var.subnets.private.name
  zone            = var.subnets.private.zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = [var.subnets.private.cidr]
  route_table_id  = yandex_vpc_route_table.nat_route_table["nat-instance"].id
}

resource "yandex_vpc_route_table" "nat_route_table" {
  for_each    = { for i in var.routes : i.route_name => i }
  network_id      = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = each.value.route_dest
    next_hop_address   = var.vm_resources.nat.int_ip
  }
}

data "yandex_compute_image" "vm_image" {
  family = var.vm_image_family
}
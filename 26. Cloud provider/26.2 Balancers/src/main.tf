resource "yandex_vpc_network" "develop" {
  name            = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  name            = var.subnets.public.name
  zone            = var.subnets.public.zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = [var.subnets.public.cidr]
}

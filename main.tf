resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr[0].cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_cidr[0].name
  }
}
module "my_network" {
  source = "./module/network"
  vpc_tobi = aws_vpc.main_vpc.id
  vpc_cidr = var.vpc_cidr
  availa_zone = var.availa_zone
  idris_prefix = var.idris_prefix
}

module "my_webserver" {
  source = "./module/weserver"
  vpc_cidr = aws_vpc.main_vpc.cidr_block
  my_ip = var.my_ip
  vpc_tobi = aws_vpc.main_vpc.id
  idris_prefix = var.idris_prefix
  instance = var.instance
  availa_zone = var.availa_zone
  public_key_location = var.public_key_location
  subnet_di = module.my_network.subnet.id

}
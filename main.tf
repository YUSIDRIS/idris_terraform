/*resource "aws_vpc" "main_vpc" {
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
}*/

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_cidr[0].name
  cidr = var.vpc_cidr[0].cidr_block

  azs             = [var.availa_zone]
  public_subnets  = [var.vpc_cidr[1].cidr_block]
  public_subnet_tags = { Name = var.vpc_cidr[1].name }
  

  tags = {
    Name = var.vpc_cidr[0].name
  }
}

module "my_webserver" {
  source = "./module/weserver"
  vpc_cidr = module.vpc.vpc_cidr_block
  my_ip = var.my_ip
  vpc_tobi = module.vpc.vpc_id
  idris_prefix = var.idris_prefix
  instance = var.instance
  availa_zone = var.availa_zone
  public_key_location = var.public_key_location
  subnet_di = module.vpc.public_subnets[0]

}
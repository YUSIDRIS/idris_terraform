variable  "vpc_cidr" {
  description= "this is for all vpcs"
  type =  list(object({
    cidr_block = string
    name = string}))
}

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr[0].cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_cidr[0].name
  }
}

output "vpc_id" {
  value= "aws_vpc.main_vpc.id"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.vpc_cidr[1].cidr_block
  availability_zone = "us-east-2a"
  map_public_ip_on_launch= true

  tags = {
    Name = var.vpc_cidr[1].name  }
}

output "subnet_id" {
  value= "aws_subnet.public_subnet_1.id"
}
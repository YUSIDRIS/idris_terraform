variable  "vpc_cidr" {
  description= "this is for all vpcs"
  type =  list(object({
    cidr_block = string
    name = string}))
}
variable "idris_prefix" {}
variable "my_ip" {}
variable "instance" {}
variable "availa_zone" {}
variable "public_key_location" {}

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr[0].cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_cidr[0].name
  }
}

output "vpc_id" {
  value= aws_vpc.main_vpc.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.vpc_cidr[1].cidr_block
  availability_zone = var.availa_zone
  map_public_ip_on_launch= true

  tags = {
    Name = var.vpc_cidr[1].name  }
} 

output "subnet_id" {
  value= aws_subnet.public_subnet_1.id
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.idris_prefix}-IGW"
  }
}

output "IGW_id" {
  value = aws_internet_gateway.IGW.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.idris_prefix}-route_table"
  }
}

output "route_table_id" {
  value = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "associte_public_route" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow Http and ssh inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main_vpc.cidr_block,var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids  = []
  }
  tags = {
    Name = "${var.idris_prefix}-SG"
  }
}

output "Sg_id" {
  value = aws_security_group.public_sg.id
}

data "aws_ami" "amazon_image" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*.0-kernel-6.1-x86_64"]
  }
   filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "aws_ami_id"{
  value = data.aws_ami.amazon_image.id
}
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_image.id
  instance_type = var.instance
  associate_public_ip_address = true
  availability_zone = var.availa_zone
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.public_subnet_1.id
  key_name = aws_key_pair.id_key.key_name
  user_data = file("data_script.sh")
  
  tags = {
    Name = "${var.idris_prefix}-webserver"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

resource "aws_key_pair" "id_key" {
  key_name   = "${var.idris_prefix}-key"
  public_key =file(var.public_key_location)
}
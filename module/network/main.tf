
resource "aws_subnet" "public_subnet_1" {
  vpc_id = var.vpc_tobi
  cidr_block = var.vpc_cidr[1].cidr_block
  availability_zone = var.availa_zone
  map_public_ip_on_launch= true

  tags = {
    Name = var.vpc_cidr[1].name  }
} 



resource "aws_internet_gateway" "IGW" {
  vpc_id = var.vpc_tobi

  tags = {
    Name = "${var.idris_prefix}-IGW"
  }
}



resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_tobi

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.idris_prefix}-route_table"
  }
}



resource "aws_route_table_association" "associte_public_route" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
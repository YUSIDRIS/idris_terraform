resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow Http and ssh inbound traffic"
  vpc_id      = var.vpc_tobi

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
    cidr_blocks      = [var.vpc_cidr,var.my_ip]
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
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_image.id
  instance_type = var.instance
  associate_public_ip_address = true
  availability_zone = var.availa_zone
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = var.subnet_di
  key_name = aws_key_pair.id_key.key_name
  user_data = file("data_script.sh")
  
  tags = {
    Name = "${var.idris_prefix}-webserver"
  }
}


resource "aws_key_pair" "id_key" {
  key_name   = "${var.idris_prefix}-key"
  public_key = file(var.public_key_location)
}
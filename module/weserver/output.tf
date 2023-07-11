output "Sg_id" {
  value = aws_security_group.public_sg.id
}
output "aws_ami_id"{
  value = data.aws_ami.amazon_image.id
}
output "instance" {
  value = aws_instance.web_server
}
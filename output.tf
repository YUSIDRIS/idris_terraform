output "vpc_id" {
  value= aws_vpc.main_vpc.id
}

output "public_ip" {
  value = module.my_webserver.instance.public_ip
}
output "vpc_id" {
  value= module.vpc.vpc_id
}

output "public_ip" {
  value = module.my_webserver.instance.public_ip
}
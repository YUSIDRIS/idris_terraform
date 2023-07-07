output "subnet" {
  value= aws_subnet.public_subnet_1
}
output "IGW_id" {
  value = aws_internet_gateway.IGW.id
}
output "route_table_id" {
  value = aws_route_table.public_route_table.id 
}

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
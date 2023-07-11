variable "vpc_tobi" {}
variable  "vpc_cidr" {
  description= "this is for all vpcs"
  type =  list(object({
    cidr_block = string
    name = string}))
}
variable "availa_zone" {}
variable "idris_prefix" {}

variable "image_name" {
  type = string
}
variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "region" {
  type = string
}

variable "allowed_ports" {
  type = list(string)
}

variable "cidr_ipv4" {
  type = string
}

variable "cidr_block" {
  type = string
}
variable "ami_id" {
  default = "ami-0ea1cddefe0c4aed5"
}
variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "key-tf"
}

variable "region" {
  default = "us-east-2"
}

variable "allowed_ports" {
  type    = list(string)
  default = ["80", "443", "27017", "22"]
}

variable "ipv4" {
  default = "0.0.0.0/0"
}

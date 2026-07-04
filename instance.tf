#createing key-pair
resource "aws_key_pair" "key-tf" {
  key_name   = var.key_name
  public_key = file("${path.module}/id_rsa.pub")
}

#creating vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#creating subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    name = "main=subnet"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#creating route table for internet gateway
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id # Tells AWS this map belongs to your neighborhood

  route {
    cidr_block = "0.0.0.0/0"                     # "If traffic wants to go to the Entire Internet..."
    gateway_id = aws_internet_gateway.gateway.id # "...send it directly to our Front Gate"
  }

  tags = { Name = "main-route-table" }
}

#creating route table association for route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id # Selects your street
  route_table_id = aws_route_table.rt.id     # Selects your map
}

#creating security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

#creating ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  for_each          = toset(var.allowed_ports)
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.ipv4
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

#creating egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#creating ec2 instance
resource "aws_instance" "my-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "first-tf-instance"
  }
}


#creating vpc
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
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
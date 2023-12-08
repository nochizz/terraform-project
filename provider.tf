provider "aws" {
  region = "eu-west-2"
}

# public route table
resource "aws_route_table" "Grace-Pub-route-table" {
  vpc_id = aws_vpc.Grace-IT-VPC.id
}

# private route table
resource "aws_route_table" "Grace-Priv-route-table" {
  vpc_id = aws_vpc.Grace-IT-VPC.id
}

# internet provider
resource "aws_internet_gateway" "Grace_internet_gateway" {
  vpc_id = aws_vpc.Grace-IT-VPC.id
}

resource "aws_eip" "nat_eip" {
  tags = { 
    name = "nat_eip"
  }
}

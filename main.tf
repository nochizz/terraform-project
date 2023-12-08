
resource "aws_vpc" "Grace-IT-VPC" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true
  enable_dns_hostnames = true
}

# public subnet 1
resource "aws_subnet" "Prod-Pub-sub1" {
  vpc_id                  = aws_vpc.Grace-IT-VPC.id
  cidr_block              = "10.0.10.0/24"  
  availability_zone       = "eu-west-2a"  
  map_public_ip_on_launch = true
}

# public subnet 2
resource "aws_subnet" "Prod-Pub-sub2" {
  vpc_id                  = aws_vpc.Grace-IT-VPC.id
  cidr_block              = "10.0.11.0/24"  
  availability_zone       = "eu-west-2b"  
  map_public_ip_on_launch = true
}

# private subnet 1
resource "aws_subnet" "Prod-Priv-sub1" {
  vpc_id                  = aws_vpc.Grace-IT-VPC.id
  cidr_block              = "10.0.12.0/24"  
  availability_zone       = "eu-west-2c"  
  map_public_ip_on_launch = true
}

# private subnet 2
resource "aws_subnet" "Prod-Priv-sub2" {
  vpc_id                  = aws_vpc.Grace-IT-VPC.id
  cidr_block              = "10.0.13.0/24"  
  availability_zone       = "eu-west-2c"  
  map_public_ip_on_launch = true
}


# public route table
resource "aws_route" "Grace-Pub-route-table" {
  route_table_id         = aws_route_table.Grace-Pub-route-table.id
  destination_cidr_block = "0.0.0.0/0" 
  gateway_id             = aws_internet_gateway.Grace_internet_gateway.id
}



# private route table association 1
resource "aws_route_table_association" "Prod-priv-route-table-1" {
  subnet_id      = aws_subnet.Prod-Priv-sub1.id
  route_table_id = aws_route_table.Grace-Priv-route-table.id
}

# private route table association 2
resource "aws_route_table_association" "Prod-priv-route-table-2" {
  subnet_id      = aws_subnet.Prod-Priv-sub2.id
  route_table_id = aws_route_table.Grace-Priv-route-table.id
}

#public route table association 1
resource "aws_route_table_association" "Prod-pub-route-table-1" {
  subnet_id      = aws_subnet.Prod-Pub-sub1.id
  route_table_id = aws_route_table.Grace-Pub-route-table.id
}
  
  #public route table association 2
resource "aws_route_table_association" "Prod-pub-route-table-2" {
  subnet_id      = aws_subnet.Prod-Pub-sub2.id
  route_table_id = aws_route_table.Grace-Pub-route-table.id
}

#create Elastic iP
resource "aws_eip" "grace_eip" {
    tags = {
      name = "grace_eip"
    }
  
}

# NAT GATEWAY
resource "aws_nat_gateway" "Grace_nat_gateway" {
  allocation_id = aws_eip.grace_eip.id
  subnet_id     = aws_subnet.Prod-Priv-sub1.id
}

#Nat associate with prive route
resource "aws_route" "Prod-priv-route-table-1" {
    route_table_id = aws_route_table.Grace-Priv-route-table.id
    gateway_id = aws_internet_gateway.Grace_internet_gateway.id
    destination_cidr_block = "0.0.0.0/0"
 

}
/*
# Create a VPC
resource "aws_vpc" "natashavpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "NatashaTerraformVPC" 
  }

  
}
# Create a pulic subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id = aws_vpc.natashavpc
  cidr_block = "10.0.2.0/24"
  
}
# Create a private subnet
resource "aws_subnet" "PrivateSubnet" {
    vpc_id = aws_vpc.natashavpc.id
    cidr_block = "10.0.2.0/24"

}

#Create igw
resource aws_internet_gateway "igw"{ 
vpc_id = aws_vpc.natashavpc

}

#route Tables for public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.natashavpc
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw
  
  }
}
# create route table association public subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id

  
}
*/
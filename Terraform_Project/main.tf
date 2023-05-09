terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "t" {
  bucket = "my-tf-t-bucket"
}

resource "aws_s3_bucket_ownership_controls" "t" {
  bucket = aws_s3_bucket.t.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "t" {
  depends_on = [aws_s3_bucket_ownership_controls.t]

  bucket = aws_s3_bucket.t.id
  acl    = "private"
}

# Create a VPC
resource "aws_vpc" "natashavpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "NatashaTerraformVPC"
  }
}

# Create a public subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.natashavpc.id
  cidr_block = "10.0.2.0/24"
}

# Create a private subnet
resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = aws_vpc.natashavpc.id
  cidr_block = "10.0.3.0/24"
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.natashavpc.id
}

# Create a route table for the public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.natashavpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

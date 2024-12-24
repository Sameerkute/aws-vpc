

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}


provider "aws" {
    region = "ap-south-1"
}


#create a VPC
resource "aws_vpc" "my-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-vpc"
    }
}

#Create Private Subnet
resource "aws_subnet" "private-subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "private-subnet"
    }
  
}

#Create Public Subnet
resource "aws_subnet" "public-subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "public-subnet"
    }
  
}

#Create Internet Gateway
resource "aws_internet_gateway" "my-igw" {
     vpc_id = aws_vpc.my-vpc.id
     tags = {
        Name = "my-igw"

     } 
}



#Creating Routing Table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id 
    }
}


# Routbe Table Association
resource "aws_route_table_association" "public-sub" {
    route_table_id = aws_route_table.my-rt.id
    subnet_id = aws_subnet.public-subnet.id
}
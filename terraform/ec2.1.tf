# configured aws provider with proper credentials
provider "aws" {
  region    = "us-east-1"
}

# create default vpc if one does not exist
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Vpc Mahfuz - Terraform"
  }
}

# use data source to get all availability zones in the region
data "aws_availability_zones" "available_zones" {}

# aws_eip
resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = {
    Name = "EIP Mahfuz"
  }
}

# nat table
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "NAT Gateway Mahfuz"
  }
}

# route gateway
resource "aws_route_table" "route_table" {
  vpc_id = aws_default_vpc.default_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Route Table Mahfuz"
  }
}

# create default subnet if one does not exist
resource "aws_subnet" "public_subnet" {
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  vpc_id                  = aws_default_vpc.default_vpc.id
  cidr_block              = cidrsubnet(aws_default_vpc.default_vpc.cidr_block, 8, 128)

  tags = {
    Name = "Subnet Mahfuz Public"
  }
}

# create security group for the EC2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 80 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group Mahfuz"
  }
}

# launch the EC2 instance and install website
resource "aws_instance" "ec2_instance" {
  count                 = 2
  ami                   = "ami-09f59285244c19131"
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name              = "MahfuzKey"
  user_data             = file("userdata.tpl")

  tags = {
    Name = "Ec2-${count.index + 1}"
  }
}
# configured aws provider with proper credentials
provider "aws" {
  alias = "second"
  region    = "us-east-1"
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones_second" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "second_az1" {
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags   = {
    Name = "Subnet Mahfuz 2"
  }
}


# launch the ec2 instance and install website
resource "aws_instance" "ec2_instance2" {
  ami                    = "ami-09f59285244c19131"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.second_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "MahfuzKey"
  # user_data              = 

  tags = {
    Name = "Aplicação ELB Mahfuz 2"
  }
}


# print the ec2's public ipv4 address
output "public_ipv4_address_instance2" {
  value = aws_instance.ec2_instance2.public_ip
}
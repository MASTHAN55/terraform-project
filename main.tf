###########################
# Author :- masthan
# Date  :-  23/09/2024
###########################
#terraform {
 # required_providers {
  #  aws = {
   #   source  = "hashicorp/aws"
    #  version = "~> 4.16"
    #}
  #}

  #required_version = ">= 1.2.0"
#}

# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  } 
}

## create 2 subnets
# Create a public subnet in the VPC
resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch  = true
}

# Create a private subnet in the VPC
resource "aws_subnet" "PrivSubnet" {
  vpc_id                   = aws_vpc.myvpc.id
  cidr_block               = "10.0.2.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false
}

# Create a Internet Gate Way
resource "aws_internet_gateway" "myIG" {
  vpc_id      = aws_vpc.myvpc.id
  
}
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "EIP"
  }
}
# create a NAT Gate Way
resource "aws_nat_gateway" "myNAT" {
  allocation_id =aws_eip.nat_eip.id
  subnet_id = aws_subnet.PublicSubnet.id
}
## create 2 Route tables
# create public route table
resource "aws_route_table" "public_RT" {
  vpc_id     = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIG.id
  }
  
}
# create a private route table
resource "aws_route_table" "private_RT"{
  vpc_id     = aws_vpc.myvpc.id
  route {
    nat_gateway_id = aws_nat_gateway.myNAT.id 
    cidr_block = "0.0.0.0/0"
  }
}

# associate public RT to public subnet
resource "aws_route_table_association" "public_association_RT" {
  subnet_id = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.public_RT.id
  
}

# associate Private RT to Private subnet
resource "aws_route_table_association" "private_association_Rt" {
subnet_id = aws_subnet.PrivSubnet.id 
route_table_id =aws_route_table.private_RT.id  
}

## create 2 security groups for instances
# security group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instance"
  vpc_id      = aws_vpc.myvpc.id 

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# security group for Docker
resource "aws_security_group" "docker_sg" {
  name        = "docker-sg"
  description = "Security group for Docker instance"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Launch instances
# Create Jenkins EC2 instance in the public subnet
resource "aws_instance" "jenkins_instance" {
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name        = var.keypair
  user_data = "${file("jenkins-userdata.sh")}"

  tags = {
    Name = "JenkinsInstance"
  }
}

# Create Docker EC2 instance in the private subnet
resource "aws_instance" "docker_instance" {
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.PrivSubnet.id
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  key_name        = var.keypair
  user_data = "${file("docker-userdata.sh")}"
  tags = {
    Name = "DockerInstance"
  }
}
# create additional instance in private subnet
resource "aws_instance" "additional_instance" {
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.PrivSubnet.id
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  key_name        = var.keypair
  tags = {
    Name = "AdditionalInstance"
  }
}

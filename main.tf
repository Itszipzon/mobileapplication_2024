provider "aws" {
  region = "eu-west-2"
}

# Data source to check for existing VPC
data "aws_vpcs" "existing" {
  filter {
    name   = "cidr-block"
    values = ["10.0.0.0/16"]
  }
}

# Create a new VPC if it does not exist
resource "aws_vpc" "main" {
  count = length(data.aws_vpcs.existing.ids) > 0 ? 0 : 1

  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    Name = "eu-west-2-vpc"
  }
}

# Use the existing VPC ID or the newly created VPC ID
locals {
  vpc_id = length(data.aws_vpcs.existing.ids) > 0 ? data.aws_vpcs.existing.ids[0] : aws_vpc.main[0].id
}

# Data source to check for existing subnets in the VPC
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

# Create a new subnet only if no existing subnets are found
resource "aws_subnet" "main" {
  count = length(data.aws_subnets.existing.ids) > 0 ? 0 : 1

  vpc_id                  = local.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "eu-west-2-subnet"
  }
}

# Use the existing subnet ID or the newly created subnet ID
locals {
  subnet_id = length(data.aws_subnets.existing.ids) > 0 ? data.aws_subnets.existing.ids[0] : aws_subnet.main[0].id
}

# Data source to check for existing Internet Gateway
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [local.vpc_id]
  }
}

# Create an Internet Gateway only if it doesn't exist
resource "aws_internet_gateway" "main" {
  count = length(data.aws_internet_gateway.existing.id) > 0 ? 0 : 1

  vpc_id = local.vpc_id
  tags = {
    Name = "eu-west-2-igw"
  }
}

# Use existing or newly created Internet Gateway
locals {
  internet_gateway_id = length(data.aws_internet_gateway.existing.id) > 0 ? data.aws_internet_gateway.existing.id : aws_internet_gateway.main[0].id
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.internet_gateway_id
  }

  tags = {
    Name = "eu-west-2-route-table"
  }
}

# Associate route table with the subnet (conditionally create association)
resource "aws_route_table_association" "main" {
  count = length(data.aws_subnets.existing.ids) > 0 ? 0 : 1

  subnet_id      = local.subnet_id
  route_table_id = aws_route_table.main.id
}

# Create a security group with rules for SSH, HTTP, and Spring Boot (8080)
resource "aws_security_group" "main" {
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = {
    Name = "eu-west-2-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "main" {
  ami           = "ami-003b7d0393f95b818"
  instance_type = "t2.micro"
  subnet_id     = local.subnet_id
  security_groups = [aws_security_group.main.id]

  tags = {
    Name = "eu-west-2-instance"
  }
}

# Outputs
output "instance_id" {
  value = aws_instance.main.id
}

output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

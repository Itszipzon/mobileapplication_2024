provider "aws" {
  region = "eu-west-2"
}

# Use an existing VPC
data "aws_vpc" "existing" {
  default = true
}

# Create a subnet in the existing VPC
resource "aws_subnet" "main" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "eu-west-2-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.existing.id
  tags = {
    Name = "eu-west-2-igw"
  }
}

# Create a security group
resource "aws_security_group" "main" {
  vpc_id = data.aws_vpc.existing.id

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

# Reference existing IAM instance profile
resource "aws_instance" "main" {
  ami           = "ami-0039f258703b10757"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]
  iam_instance_profile = "pipeline_user"

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

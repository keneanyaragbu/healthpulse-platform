terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "aws_key_pair" "k3s" {
  key_name   = "${var.project_name}-k3s-key"
  public_key = var.ssh_public_key
}

resource "aws_vpc" "k3s" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-k3s-vpc"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.k3s.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-k3s-public-subnet"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_internet_gateway" "k3s" {
  vpc_id = aws_vpc.k3s.id

  tags = {
    Name    = "${var.project_name}-k3s-igw"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k3s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k3s.id
  }

  tags = {
    Name    = "${var.project_name}-k3s-public-rt"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "k3s" {
  name        = "${var.project_name}-k3s-sg"
  description = "Security group for k3s cluster"
  vpc_id      = aws_vpc.k3s.id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "Kubernetes API from allowed CIDR"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS public access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all internal cluster traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-k3s-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.master_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = aws_key_pair.k3s.key_name

  user_data = templatefile("${path.module}/scripts/master-deploy.sh", {
    k3s_token = random_password.k3s_token.result
  })

  tags = {
    Name    = "${var.project_name}-k3s-master"
    Role    = "master"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_eip" "master" {
  instance = aws_instance.master.id
  domain   = "vpc"

  tags = {
    Name    = "${var.project_name}-k3s-master-eip"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.worker_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = aws_key_pair.k3s.key_name

  user_data = templatefile("${path.module}/scripts/worker-deploy.sh", {
    master_ip    = aws_instance.master.private_ip
    k3s_token    = random_password.k3s_token.result
    worker_index = count.index + 1
  })

  depends_on = [aws_instance.master]

  tags = {
    Name    = "${var.project_name}-k3s-worker-${count.index + 1}"
    Role    = "worker"
    Project = var.project_name
    Env     = var.environment
  }
}

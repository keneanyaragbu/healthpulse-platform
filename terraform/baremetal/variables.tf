variable "aws_region" {
  description = "AWS region for provisioning resources"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging AWS resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your public IP address in CIDR format for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key used to access the EC2 instance"
  type        = string
}

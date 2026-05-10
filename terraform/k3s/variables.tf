variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key used for EC2 access"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH and access Kubernetes API"
  type        = string
}

variable "master_instance_type" {
  description = "EC2 instance type for k3s master"
  type        = string
}

variable "worker_instance_type" {
  description = "EC2 instance type for k3s workers"
  type        = string
}

variable "worker_count" {
  description = "Number of k3s worker nodes"
  type        = number
}

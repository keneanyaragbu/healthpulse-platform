aws_region   = "us-east-1"
project_name = "healthpulse"
environment  = "prod"
vpc_cidr           = "10.40.0.0/16"
public_subnet_cidr = "10.40.1.0/24"
master_instance_type = "t3.medium"
worker_instance_type = "t3.medium"
worker_count         = 3

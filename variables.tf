variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

# VPC
variable "vpc" {
  type = map(any)
}

variable "vpc_cidr_block" {
  type    = string
  default = "172.31.0.0/16"
}

# RDS
variable "rds_database" {
  type = map(any)
}

# LOAD BALANCER
variable "load_balancer" {
  type = map(any)
}

# EC2
variable "ec2" {
  type = map(any)

  validation {
    condition     = var.ec2["instance_count"] > 0
    error_message = "The \"instance_count\" key must be greater than 0. Please update the 'ec2' variable in your Terraform configuration."
  }
}

variable "mtc_formation_internal_ip" {
  type = string
}

variable "deployment_file_name" {
  type = string
}

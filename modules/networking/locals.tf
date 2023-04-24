locals {
  security_groups = {
    public = {
      name        = "mtc_public_sg"
      description = "instances security group"

      ingress = {
        ssh = {
          description = "SSH from mtc-formation"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [var.ssh_access_ip]
        }
        pod_port = {
          description     = "8000 from public load balancer"
          from_port       = 8000
          to_port         = 8000
          protocol        = "tcp"
          security_groups = [aws_security_group.mtc_lb_sg["load_balancer"].id]
        }
      }
    }
    rds = {
      name        = "mtc_rds_sg"
      description = "rds security group"

      ingress = {
        ssh = {
          description = "3306 from vpc"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr_block]
        }
      }
    }
  }
  load_balancer_security_groups = {
    load_balancer = {
      name        = "mtc_load_balancer_sg"
      description = "load balancer security group"

      ingress = {
        http = {
          description = "HTTP from VPC"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = [var.ssh_access_ip]
        }
      }
    }
  }
}

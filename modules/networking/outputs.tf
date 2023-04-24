# --- networking/outputs.tf ---

output "vpc_id" {
  value       = aws_vpc.mtc_vpc.id
  description = "AWS VPC IDENTIFIER"
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.*.name
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "db_security_group" {
  value = aws_security_group.mtc_sg["rds"].id
}

output "public_security_group" {
  value = aws_security_group.mtc_sg["public"].id
}

output "load_balancer_security_group" {
  value = aws_security_group.mtc_lb_sg["load_balancer"].id
}
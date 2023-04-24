output "lb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "load_balancer_dns" {
  value = aws_lb.this.dns_name
}
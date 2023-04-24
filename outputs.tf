output "db_details" {
  value = var.rds_database
}


output "load_balancer_dns" {
  value = module.load_balancer.load_balancer_dns
}

output "instances" {
  value = {
    for e in module.compute.instances : e.tags.Name => e.public_ip
  }
}

output "instance_target_for_ssm" {
  value = {
    id = module.compute.instances[0].id
    ip = module.compute.instances[0].public_ip
  }
}

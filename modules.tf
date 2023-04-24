# -- root/modules.tf --

module "networking" {
  source                  = "./modules/networking"
  vpc_cidr_block          = local.vpc_cidr_block
  public_sub_count        = var.vpc.public_sub_count
  private_sub_count       = var.vpc.private_sub_count
  max_subnets             = 20
  vpc_private_cidr_blocks = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr_block, 8, i)]
  vpc_public_cidr_blocks  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr_block, 8, i)]
  ssh_access_ip           = var.vpc.ssh_access_ip
  is_db_subnet_group      = var.vpc.is_db_subnet_group
}

module "database" {
  depends_on             = [module.networking.vpc_id]
  source                 = "./modules/database"
  allocated_storage      = var.rds_database.allocated_storage
  db_name                = var.rds_database.db_name
  db_identifier          = var.rds_database.identifier
  engine                 = var.rds_database.engine
  engine_version         = var.rds_database.engine_version
  instance_class         = var.rds_database.instance_class
  username               = sensitive(var.rds_database.username)
  password               = sensitive(var.rds_database.password)
  parameter_group_name   = var.rds_database.parameter_group_name
  skip_final_snapshot    = var.rds_database.skip_final_snapshot
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = [module.networking.db_security_group]
}

module "load_balancer" {
  depends_on = [module.networking.vpc_id]
  source     = "./modules/load_balancer"
  access_logs = {
    bucket     = module.s3.mtc_bucket
    prefix     = var.load_balancer.access_logs_prefix
    is_enabled = var.load_balancer.access_logs_is_enabled
  }
  lb_name                = var.load_balancer.name
  internal               = var.load_balancer.internal
  lb_type                = var.load_balancer.type
  lb_security_group_ids  = [module.networking.load_balancer_security_group]
  lb_subnet_ids          = module.networking.public_subnet_ids
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = var.load_balancer.healthy_threshold
  lb_unhealthy_threshold = var.load_balancer.unhealthy_threshold
  lb_timeout             = var.load_balancer.timeout
  lb_interval            = var.load_balancer.interval

}

module "s3" {
  source = "./modules/s3"
}

module "compute" {
  source               = "./modules/compute"
  instance_count       = var.ec2.instance_count
  instance_type        = var.ec2.instance_type
  public_sg            = [module.networking.public_security_group]
  public_subnets       = module.networking.public_subnet_ids
  root_volume_size     = var.ec2.root_volume_size
  key_pair_name        = var.ec2.key_pair_name
  key_pair_path        = var.ec2.key_pair_path
  user_data_path       = "${path.root}/modules/compute/userdata/${var.ec2.user_data_filename}"
  dbuser               = var.rds_database.username
  dbpass               = var.rds_database.password
  db_endpoint          = module.database.db_endpoint
  dbname               = var.rds_database.db_name
  lb_target_group_arn  = module.load_balancer.lb_target_group_arn
  deployment_file_name = var.deployment_file_name
}

module "ssm" {
  depends_on           = [module.compute.instances]
  source               = "./modules/ssm"
  deployment_file_name = var.deployment_file_name
  instance_id          = module.compute.instances[0].id
}
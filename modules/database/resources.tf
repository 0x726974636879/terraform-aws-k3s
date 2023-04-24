resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  identifier             = var.db_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name        = "mtc_database"
    Environment = "Dev"
  }
}
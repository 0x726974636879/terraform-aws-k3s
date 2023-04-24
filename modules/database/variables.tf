variable "allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "db_subnet_group_name" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}

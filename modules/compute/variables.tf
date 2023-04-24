variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}
variable "public_sg" {
  type = list(any)
}
variable "public_subnets" {
  type = list(any)
}

variable "root_volume_size" {
  type = number
}

variable "key_pair_name" {
  type = string
}
variable "key_pair_path" {
  type = string
}

variable "user_data_path" {
  type = string
}

variable "dbuser" {
  type = string
}
variable "dbpass" {
  type = string
}
variable "db_endpoint" {
  type = string
}
variable "dbname" {
  type = string
}

variable "lb_target_group_arn" {
  type = string
}

variable "deployment_file_name" {
  type = string
}
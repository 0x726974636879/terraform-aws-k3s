# --- networking/variables.tf

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_public_cidr_blocks" {
  type = list(string)
}

variable "vpc_private_cidr_blocks" {
  type = list(string)
}

variable "public_sub_count" {
  type = number
}

variable "private_sub_count" {
  type = number
}

variable "max_subnets" {
  type = number
}

variable "ssh_access_ip" {
  type = string
}

variable "is_db_subnet_group" {
  type = bool
}

variable "mtc_formation_internal_ip" {
  type = string
}
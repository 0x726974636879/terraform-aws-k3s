variable "lb_name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "lb_type" {
  type = string
}

variable "lb_security_group_ids" {
  type = list(string)
}

variable "lb_subnet_ids" {
  type = list(string)
}

variable "access_logs" {
  type = map(any)
}

variable "vpc_id" {
  type = string
}

variable "lb_healthy_threshold" {
  type = number
}
variable "lb_unhealthy_threshold" {
  type = number
}
variable "lb_timeout" {
  type = number
}
variable "lb_interval" {
  type = number
}
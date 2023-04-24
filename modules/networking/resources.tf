# --- networking/resources.tf --- 

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "mtc_vpc_${random_integer.random.id}"
    Environment = "Dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_sub_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.vpc_public_cidr_blocks[count.index]
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "mtc_public_subnet_${count.index + 1}"
    Environment = "Dev"
  }
}
resource "aws_subnet" "private" {
  count             = var.private_sub_count
  vpc_id            = aws_vpc.mtc_vpc.id
  cidr_block        = var.vpc_private_cidr_blocks[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name        = "mtc_private_subnet_${count.index + 1}"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = var.public_sub_count
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id

  tags = {
    Name        = "mtc_default_route"
    Environment = "Dev"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name        = "mtc_public_route_table"
    Environment = "Dev"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name        = "mtc_internet_gateway"
    Environment = "Dev"
  }
}

resource "aws_security_group" "mtc_sg" {
  for_each    = local.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description     = ingress.value["description"]
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = each.value.name
    Environment = "Dev"
  }
}

resource "aws_security_group" "mtc_lb_sg" {
  for_each    = local.load_balancer_security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description     = ingress.value["description"]
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = each.value.name
    Environment = "Dev"
  }
}


resource "aws_db_subnet_group" "this" {
  count      = var.is_db_subnet_group ? 1 : 0
  name       = "mtc_rds_subnet_group"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name        = "mtc_rds_subnet_group"
    Environment = "Dev"
  }
}
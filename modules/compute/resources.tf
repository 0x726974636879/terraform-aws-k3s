resource "random_id" "this" {
  count       = var.instance_count
  byte_length = 2

  keepers = {
    key_name = var.key_pair_name
  }
}

resource "random_shuffle" "subnet_list" {
  input        = var.public_subnets
  result_count = var.instance_count
}

resource "aws_instance" "ubuntu" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.public_sg
  subnet_id              = random_shuffle.subnet_list.result[count.index]
  key_name               = aws_key_pair.this.key_name
  iam_instance_profile   = aws_iam_instance_profile.this.id
  user_data = templatefile(
    var.user_data_path,
    {
      nodename    = "mtcubuntu${random_id.this[count.index].dec}"
      dbuser      = var.dbuser
      dbpass      = var.dbpass
      db_endpoint = var.db_endpoint
      dbname      = var.dbname
    }
  )

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = {
    Name        = "mtcubuntu${random_id.this[count.index].dec}"
    Environment = "Dev"
  }
}

resource "aws_key_pair" "this" {
  key_name   = var.key_pair_name
  public_key = sensitive(file(var.key_pair_path))
}


resource "aws_lb_target_group_attachment" "this" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.ubuntu[count.index].id
  port             = 8000
}

resource "aws_iam_role" "this" {
  name = "mtcec2role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "1"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.amazon_ssm_managed_instance_core.arn]
}

resource "aws_iam_instance_profile" "this" {
  name = "${aws_iam_role.this.name}profile"
  role = aws_iam_role.this.name
}

resource "null_resource" "scp_ssm_script" {
  depends_on = [aws_instance.ubuntu]
  provisioner "local-exec" {
    command = templatefile(
      local.ssm_script_file_path,
      {
        key_pair_name        = var.key_pair_name
        deployment_file_path = local.deployment_file_path
        instance_public_ip   = aws_instance.ubuntu[0].public_ip
        instance_id          = aws_instance.ubuntu[0].id
      }
    )
  }
}

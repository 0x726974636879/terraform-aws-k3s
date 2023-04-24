locals {
  deployment_file_path = "${path.module}/files/${var.deployment_file_name}"
  ssm_script_file_path = "${path.module}/files/ssm_script.tpl"
}
# Terraform Configuration for k3s Infrastructure

This project is a Terraform configuration that allows you to create an infrastructure on AWS containing a VPC, a load balancer, and EC2 instances. The instances are used as nodes for K3s, which will launch Nginx. The Terraform state files are stored on Terraform Cloud.

With this configuration, you can easily create a scalable and reliable infrastructure on AWS that can be used to host web applications or other services. The use of K3s and Nginx allows for easy management and deployment of containerized applications, while the use of Terraform Cloud ensures that the infrastructure is properly managed and maintained.

## Prerequisites

- Terraform 4.0.x or higher
- An AWS account with the necessary permissions
- A `.tfvars` variable file at the root of the project
- Two environment variables added to your `.bashrc` or `.zshrc` file:
  - `TF_CLOUD_ORGANIZATION`: The name of your Terraform Cloud organization, if you're using Terraform Cloud to manage your state.
  - `TF_WORKSPACE`: The name of the workspace you're using in Terraform Cloud, if you're using Terraform Cloud to manage your state.
- `tflint` installed on your local machine if you plan to make modifications to the infrastructure. `tflint` is an optional tool that checks the quality of your Terraform code and reports potential errors, ([documentation here](https://github.com/terraform-linters/tflint)).

## Variables

Before deploying the infrastructure, you must create a `.tfvars` variable file at the root of the project. This file should contain the types for the following variables:

```
# VPC
vpc = {
  public_sub_count   = number
  private_sub_count  = number
  ssh_access_ip      = string
  is_db_subnet_group = bool
}

# RDS
rds_database = {
  allocated_storage    = number
  db_name              = string
  identifier           = string
  engine               = string
  engine_version       = string
  instance_class       = string
  username             = string
  password             = string
  parameter_group_name = string
  skip_final_snapshot  = bool
}

# LOAD BALANCER
load_balancer = {
  name                   = string
  internal               = bool
  access_logs_prefix     = string
  access_logs_is_enabled = bool
  type                   = string
  healthy_threshold      = number
  unhealthy_threshold    = number
  timeout                = number
  interval               = number
}

# EC2
ec2 = {
  instance_type      = string
  instance_count     = number
  root_volume_size   = number
  key_pair_name      = string
  key_pair_path      = string
  user_data_filename = string
}

deployment_file_name      = "deployment.yaml" #(modules/computes/files)
```

You must replace the default values for these variables with the types specific to your environment.

## Deployment

To deploy the infrastructure, run the following commands:

```
terraform init
terraform apply -var-file=<variable_file_name>.tfvars
```

Make sure to replace `<variable_file_name>` with the name of your `.tfvars` variable file.

## Cleanup

To remove the infrastructure, run the following command:

```
terraform destroy -var-file=<variable_file_name>.tfvars
```

Make sure to replace `<variable_file_name>` with the name of your `.tfvars` variable file.

Also, make sure to verify that all resources have been properly removed after running the `terraform destroy` command.

## Modifying the Infrastructure

When making changes to the Terraform code, it's important to ensure that the code is properly formatted, validated, and of good quality before deploying it to the infrastructure. To do this, we recommend using the following command:

```
terraform fmt -recursive && terraform validate && tflint && terraform plan
```

Here's what each of these commands does:

- `terraform fmt -recursive`: This command formats the Terraform code to be readable and consistent. It's recommended to run this command before validating and planning the infrastructure to avoid syntax errors.
- `terraform validate`: This command checks the syntax and semantics of the Terraform code and reports potential errors. It's recommended to run this command after the `terraform fmt` command.
- `tflint`: This command checks the quality of the Terraform code and reports potential errors. It's recommended to run this command after the `terraform validate` command.
- `terraform plan`: This command simulates the execution of changes on the infrastructure and displays the actions that will be taken. It's recommended to run this command after the `terraform fmt`, `terraform validate`, and `tflint` commands.
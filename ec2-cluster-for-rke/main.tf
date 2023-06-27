provider "aws" {
  region = var.region
}

module "aws_server_predefined_config" {
  source        = "../servers-aws"
  ssh_key_name  = var.ssh_key_name
  instance_type = var.instance_type
  region        = var.region
  node_count    = var.node_count
}

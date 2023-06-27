output "publicips" {
	value = module.aws_server_predefined_config.public_ips
}

output "privateips" {
	value = module.aws_server_predefined_config.private_ips
}
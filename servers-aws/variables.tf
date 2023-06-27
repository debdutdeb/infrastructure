variable "ssh_key_name" {
  type        = string
  description = "SSH key name in aws account"
}

variable "instance_type" {
  type        = string
  description = "type of aws instance to use"
  default     = "t2.medium"
}

variable "region" {
  type        = string
  description = "aws region"
}

variable "node_count" {
  type    = number
  default = 1
}

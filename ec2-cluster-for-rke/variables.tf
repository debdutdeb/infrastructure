variable "ssh_key_name" {
  type        = string
  description = "ssh key name as saved in your aws account"
}

variable "region" {
  type = string

}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "node_count" {
  type = number
}

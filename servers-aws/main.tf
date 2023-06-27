data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] // my boi canonical
}

resource "aws_security_group" "cluster_group" {
  name = "cluster-group"
  egress {
    description = "incoming all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "rke"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    // FIXME: only allow the cluster to communicate
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "servers" {
  name = "ec2-cluster"
  block_device_mappings {
    device_name = tolist(data.aws_ami.ubuntu.block_device_mappings)[0].device_name
    ebs {
      volume_size           = 30
      delete_on_termination = true
    }
  }
  image_id      = data.aws_ami.ubuntu.id
  key_name      = var.ssh_key_name
  instance_type = var.instance_type
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.cluster_group.id]
  }
  placement {
    availability_zone = data.aws_availability_zones.availability_zone.id
  }
}

data "aws_availability_zones" "availability_zone" {
  filter {
    name   = "region-name"
    values = [var.region]
  }
  state = "available"
}

resource "aws_instance" "nodes" {
  launch_template {
    id = aws_launch_template.servers.id
  }
  count = var.node_count
}


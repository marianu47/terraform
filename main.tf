locals {
  instances = [
    for instance in csvdecode(file("./instance_types.csv")) : {
      name          = trimspace(instance.name)
      ami           = trimspace(instance.ami)
      instance_type = trimspace(instance.instance_type)
    }
  ]
  ssh_key_path = "./ansible_key" # path of pre-generated key pair (root path of main.tf)
}

resource "aws_key_pair" "devops" {
  key_name   = "devops"
  public_key = file("${local.ssh_key_path}.pub")
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_security_group" "ssh" { # allow incoming ssh & disallow outgoing
  name   = "ssh_access"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.8"

  count                       = length(local.instances)
  name                        = local.instances[count.index].name
  key_name                    = aws_key_pair.devops.key_name
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = false
  ami                         = local.instances[count.index].ami
  instance_type               = local.instances[count.index].instance_type
  user_data = <<-EOF
    #!/bin/bash
    password=$(head -c 32 /dev/urandom | base64)
    echo "root:\$password" | chpasswd
    echo "$password" > /tmp/root_password.txt
  EOF
}

output "instance_ip_addr" {
  description = "Private IPs of EC2 instances"
  value       = module.ec2_instances[*].private_ip
}

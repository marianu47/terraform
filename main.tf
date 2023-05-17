locals {
    instances = csvdecode(file("./instance_types.csv"))
    ssh_key_path     = "./devops"   #path of pre-generated .pem (root path of main.tf)
    vpc_id           = "vpc-01bc4dc865a353b23"  #my default vpc (demo)
}

resource "aws_key_pair" "devops" {
  key_name   = "devops"
  public_key = file("${local.ssh_key_path}.pub")
}

resource "aws_security_group" "ssh" {   #allow incoming ssh & disallow outgoing
  name   = "ssh_access"
  vpc_id = local.vpc_id

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
    version                     = "5.0.0"
    count                       = length(local.instances)
    source                      = "terraform-aws-modules/ec2-instance/aws"
    name                        = local.instances[count.index].name
    key_name                    = aws_key_pair.devops.key_name
    vpc_security_group_ids      = ["${aws_security_group.ssh.id}"]
    associate_public_ip_address = true
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
  value = module.ec2_instances[*].public_ip
  description = "IPs of EC2"
}

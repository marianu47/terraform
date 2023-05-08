locals {
    instances = csvdecode(file("./instance_types.csv"))
}

module "ec2_instances" {
    version = "5.0.0"
    count = length(local.instances)
    source = "terraform-aws-modules/ec2-instance/aws"
    name = local.instances[count.index].name
    ami = local.instances[count.index].ami
    instance_type = local.instances[count.index].instance_type
    user_data = <<-EOF
        #!/bin/bash
        password=$(head -c 32 /dev/urandom | base64)
        echo "root:\$password" | chpasswd
        echo "$password" > /tmp/root_password.txt
    EOF
}

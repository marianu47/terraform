Terraform project for creating EC2 instances with custom ami and instance_type read from a csv file.

In order to use te project run the following:

```export TF_VAR_ak="aws_project_access_key"```
```export TF_VAR_sk="aws_project_secret_key"``` #for the AK/SK, it is not recommended to generate them on the root account

```terraform init``` (optional ```-input=false```) #here you can add a custom state storage (S3, gitlab) if you've configured it. Example: ```-backend-config=./someenv/gitlab.tfbackend```

For the next commands, you can customize also the parallelism of the creation tasks ```-parallelism=1``` or even specify a .tfvars file ```-var-file=``` (not recommanded to store secrets in plain text.

```terraform plan -input=false```

```terraform apply -input=false -auto-approve```

Details:
- ak/sk variables are marked as sensitive
- the EC2 creation is not customized to deploy in a specific subnet but it uses the 'default' Subnet of the 'default' VPC
- the region is hardcoded to "eu-west-3" for convenience
- the tf state is local as its a demo and not production grade
- for the CSV file, I'm using 'Local Values' to assign a name to a csv decode function that produces a list of maps from a local csv file
- ec2 instances creation is performed with the "ec2_instances" module using latest version and not using a local source but the downloaded source (if you'll use it in an already existing tf project, you'll need to run ```terraform init -upgrade``` if this module was not previously used with version 5.0.0
- the line of ```code count = length(local.instances)``` is used to determine the number of EC2 instances that will be created based on the number of instances specified in the local.instances variable.
- for name, ami and instance_type: the count.index expression is used to access the current index of the count loop, which starts at 0 and increments by 1 for each instance created. When ```local.instances``` list is defined with 6 objects which are ```name, ami, instance_type``` and their respective desired values, the expressions ```local.instances[count.index].name```, ```local.instances[count.index].ami```, ```local.instances[count.index].instance_type``` will evaluate the local variables from the csv and will produce the desired outcome on creation.
- the user_data contains a set of bash commands that generate a random password for each ec2 creation and encode it then store it to the local file in the ec2. Ideally  we should use AWS KMS with sops or AWS Secrets Manager. The 'goto' guide I would default to using is https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1

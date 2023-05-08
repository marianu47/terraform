Terraform project for creating EC2 instances with custom ami and instance_type read from a csv file.

In order to use te project run the following:

```export TF_VAR_ak="aws_project_access_key"```
```export TF_VAR_sk="aws_project_secret_key"``` #for the AK/SK, it is not recommended to generate them on the root account

```terraform init``` (optional ```-input=false```) #here you can add a custom state storage (S3, gitlab) if you've configured it. Example: ```-backend-config=./someenv/gitlab.tfbackend```

For the next commands, you can customize also the parallelism of the creation tasks ```-parallelism=1``` or even specify a .tfvars file ```-var-file=``` (not recommanded to store secrets in plain text.

```terraform plan -input=false```

```terraform apply -input=false -auto-approve```

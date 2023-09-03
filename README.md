# aws-datalake-core

### Prerequisites

- Configure ~/.aws/credentials with your AWS credentials
- Configure ~/.ssh/aws-datalake-core.pub with some SSH key to access EC2
- Configure `export AWS_ACCOUNT="770802840260"` with your account id
- Configure `export AWS_DEFAULT_REGION="us-east-2"` with same region in ./terraform/config/variable.tf

### To run infrastructure

- Run `terraform init` if you haven't already
- Run `terraform plan --save`, then validate the generated plan about the resources
- Run `terraform apply`, after this the infrastructure should be available in AWS

### Result

- After run, terraform will print DNS of alb, then you can access airflow ui and flower as example:
Airflow ui: http://alb-1454002003.us-east-2.elb.amazonaws.com/home
Flower: http://alb-1454002003.us-east-2.elb.amazonaws.com:5555/

<span style="color:red">DON'T FORGET TO RUN `terraform destroy` AFTER USE!</span>

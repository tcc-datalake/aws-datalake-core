# aws-datalake-core

### Prerequisites

- Configure ~/.aws/credentials with your AWS credentials
- Configure ~/.ssh/aws-datalake-core.pub with some SSH key to access EC2

### To run infrastructure

- Run `terraform init` if you haven't already
- Run `terraform plan --save`, then validate the generated plan about the resources
- Run `terraform apply`, after this the infrastructure should be available in AWS

<span style="color:red">DON'T FORGET TO RUN `terraform destroy` AFTER USE</span>

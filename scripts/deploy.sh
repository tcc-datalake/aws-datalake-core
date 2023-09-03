#!/usr/bin/env bash
ACTION=$1
IMAGE_NAME=$2

# Deploy Terraform
cd ../terraforms/config/
terraform init

if [ "$ACTION" == "apply" ]; then
  terraform apply -auto-approve
  cd ../../

  ### ECR - build images and push to remote repository
  echo "Building image: $IMAGE_NAME:latest"

  docker build --rm -t $IMAGE_NAME:latest .

  eval $(aws ecr get-login-password)

  aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

  # tag and push image using latest
  docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
  docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest

else
  # terraform destroy -var "image_version=latest" -auto-approve
  terraform destroy -auto-approve
fi

#!/usr/bin/env bash

ACTION=$1

function build_image_and_push_to_ecr() {
  IMAGE_NAME=airflow

  echo "Building image: $IMAGE_NAME:latest"

  docker build --rm -t $IMAGE_NAME:latest .

  eval $(aws ecr get-login-password)

  aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

  docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
  docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
}

cd ../terraforms/config/
terraform init

if [ "$ACTION" == "apply" ]; then
  terraform apply -auto-approve
  cd ../../

  build_image_and_push_to_ecr

elif [ "$ACTION" == "plan" ]; then
  terraform plan

else
  terraform destroy -auto-approve

fi

#!/usr/bin/env bash

ACTION=$1
IMAGE_NAME=$2
should_build_docker_image=0

function generate_target() {
  INFRA_CONFIG_FILE='../application/infra.json'

  if [ ! -e "$INFRA_CONFIG_FILE" ]; then
    echo "File $INFRA_CONFIG_FILE not exists"
    exit 1
  fi

  AIRFLOW=$(jq -r '.airflow' "$INFRA_CONFIG_FILE")
  AIRBYTE=$(jq -r '.airbyte' "$INFRA_CONFIG_FILE")

  dependencies=("network" "iam" "s3" "glue")

  if [ "$AIRFLOW" == "true" ]; then
    airflow_dependencies=("cloudwatch" "alb" "rds" "elasticache" "ecs")
    dependencies=("${dependencies[@]}" "${airflow_dependencies[@]}")
    should_build_docker_image=1
  fi

  if [ "$AIRBYTE" == "true" ]; then
    airbyte_dependencies=("airbyte")
    dependencies=("${dependencies[@]}" "${airbyte_dependencies[@]}")
  fi

  target_string=""

  for element in "${dependencies[@]}"; do
    target_string+=" -target=module.$element"
  done

  echo "$target_string"
}

function build_image_and_push_to_ecr() {
  ### ECR - build images and push to remote repository
  echo "Building image: $IMAGE_NAME:latest"

  docker build --rm -t $IMAGE_NAME:latest .

  eval $(aws ecr get-login-password)

  aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

  # tag and push image using latest
  docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
  docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
}

TARGET_MODULES=$(generate_target)

echo "Target modules: $TARGET_MODULES"

cd ../terraforms/config/
terraform init

if [ "$ACTION" == "apply" ]; then
  terraform apply $TARGET_MODULES -auto-approve
  cd ../../

  if [ "$should_build_docker_image" == 1 ]; then
    build_image_and_push_to_ecr
  fi

elif [ "$ACTION" == "plan" ]; then
  terraform plan $TARGET_MODULES

else
  terraform destroy $TARGET_MODULES -auto-approve

fi

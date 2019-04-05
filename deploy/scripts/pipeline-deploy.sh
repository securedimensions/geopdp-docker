#!/usr/bin/env bash

# set script defaults
AWS_ACCOUNT_ID=495137994720
PROFILE=rndtools_ogc
REGION=us-east-1

# Get the environment variables for use in the deployment templates
export CLOUDFORMATION_BUCKET=$(aws ssm get-parameters --names "/build/cloudformation/bucket/name" --profile $PROFILE --region $REGION | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export POWERUSER_ROLE_ARN=$(aws ssm get-parameters --names "/build/poweruser/arn" --profile $PROFILE --region $REGION | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')

# Deploy the stacks
mvn cloudformation:deploy

# Login to AWS Elastic Container Repository Service
$(aws ecr get-login --no-include-email --region $REGION)

# Build and Push the Docker container to the AWS Container Registry
GEOPDP_LATEST=$(aws ssm get-parameters --names "/build/docker/geopdp_latest" --profile $PROFILE --region $REGION | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
GEOPDP_LATEST=0$GEOPDP_LATEST
GEOPDP_LATEST=$(expr $GEOPDP_LATEST + 1)
aws ssm put-parameter --name "/build/docker/geopdp_latest" --value $GEOPDP_LATEST --type "String" --overwrite --profile $PROFILE --region $REGION > /dev/null 2>&1
docker build --tag geopdp:v$GEOPDP_LATEST .
docker tag geopdp:v$GEOPDP_LATEST $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/geopdp:v$GEOPDP_LATEST
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/geopdp:v$GEOPDP_LATEST

# Record new version
echo $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/geopdp_latest:v$GEOPDP_LATEST > target/deployed.txt

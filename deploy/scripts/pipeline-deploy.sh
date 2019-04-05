#!/usr/bin/env bash

# Get the environment variables for use in the deployment templates
export REPO_CENTRAL_NAME=$(aws ssm get-parameters --names "/build/repository/central/name" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_SNAPSHOT_NAME=$(aws ssm get-parameters --names "/build/repository/snapshot/name" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_CENTRAL_URL=$(aws ssm get-parameters --names "/build/repository/central/url" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_SNAPSHOT_URL=$(aws ssm get-parameters --names "/build/repository/snapshot/url" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_CENTRAL_PLUGIN_NAME=$(aws ssm get-parameters --names "/build/repository/central/plugin/name" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_SNAPSHOT_PLUGIN_NAME=$(aws ssm get-parameters --names "/build/repository/snapshot/plugin/name" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_CENTRAL_PLUGIN_URL=$(aws ssm get-parameters --names "/build/repository/central/plugin/url" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export REPO_SNAPSHOT_PLUGIN_URL=$(aws ssm get-parameters --names "/build/repository/snapshot/plugin/url" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export CLOUDFORMATION_BUCKET=$(aws ssm get-parameters --names "/build/cloudformation/bucket/name" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')
export POWERUSER_ROLE_ARN=$(aws ssm get-parameters --names "/build/poweruser/arn" --profile rndtools_ogc --region us-east-1 | awk '/"Value"/ {print $2}' | sed -e 's/^"//' -e 's/",$//')

# Deploy the stacks
mvn cloudformation:deploy -P Master

#!/bin/bash
aws cloudformation create-stack \
  --stack-name cicd-pipeline \
  --template-body file://TapStack.yml \
  --capabilities CAPABILITY_IAM \
  --region us-west-2
echo "Pipeline deploying..."

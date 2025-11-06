#!/bin/bash
aws cloudformation delete-stack \
  --stack-name cicd-pipeline \
  --region us-west-2
echo "Pipeline deleting..."

#!/bin/bash
aws cloudformation validate-template \
  --template-body file://TapStack.yml \
  --region us-west-2
echo "✅ Template valid"

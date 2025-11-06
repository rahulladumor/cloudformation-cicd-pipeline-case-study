# 🚀 Deployment Guide

## Prerequisites

- AWS CLI
- Code repository
- S3 bucket for source

## Steps

### 1. Deploy Stack
```bash
aws cloudformation create-stack \
  --stack-name cicd-pipeline \
  --template-body file://TapStack.yml \
  --capabilities CAPABILITY_IAM \
  --region us-west-2
```

### 2. Configure Source
```bash
# Create buildspec.yml
cat > buildspec.yml << 'SPEC'
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 18
  build:
    commands:
      - npm install
      - npm test
      - npm run build
artifacts:
  files:
    - '**/*'
SPEC

# Upload to S3
zip -r app.zip .
aws s3 cp app.zip s3://YOUR-SOURCE-BUCKET/
```

### 3. Monitor
```bash
# Check pipeline status
aws codepipeline get-pipeline-state \
  --name MyPipeline

# View build logs
aws logs tail /aws/codebuild/MyBuildProject --follow
```

## Troubleshooting

**Build fails**: Check buildspec.yml syntax
**Pipeline stuck**: Check IAM permissions
**No notification**: Verify SNS subscription

# 🚀 Quick Start - CI/CD Pipeline

## Deploy (2 minutes)

```bash
aws cloudformation create-stack \
  --stack-name cicd-pipeline \
  --template-body file://TapStack.yml \
  --capabilities CAPABILITY_IAM \
  --region us-west-2
```

## Test Pipeline (1 minute)

```bash
# Upload code to trigger pipeline
aws s3 cp app.zip s3://SOURCE_BUCKET/app.zip

# Watch pipeline
aws codepipeline list-pipeline-executions \
  --pipeline-name MyPipeline
```

## ✅ Done!

Pipeline will:
1. Detect code upload
2. Start CodeBuild
3. Run tests
4. Execute Lambda validation
5. Send SNS notification

**Cost**: ~$30-40/month

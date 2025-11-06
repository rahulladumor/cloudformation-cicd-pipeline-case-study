# 🚀 CI/CD Pipeline Infrastructure - AWS CloudFormation Case Study

> **Fully automated deployment pipeline** using AWS native services

[![CloudFormation](https://img.shields.io/badge/CloudFormation-YAML-orange.svg)](https://aws.amazon.com/cloudformation/)
[![DevOps](https://img.shields.io/badge/DevOps-CI%2FCD-blue.svg)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 🎯 Problem Statement

A development team needs **automated CI/CD pipeline** that:
- Triggers automatically on code changes
- Builds and tests code
- Validates deployments
- Provides visibility into pipeline status
- Follows security best practices
- Costs minimal for small teams

## 💡 Solution

Complete serverless CI/CD pipeline using:
- **CodePipeline**: Orchestration
- **CodeBuild**: Build and test
- **Lambda**: Custom validations
- **S3**: Artifact storage
- **CloudWatch**: Monitoring and logs
- **SNS**: Notifications

## 🏗️ Architecture

```
S3 Source Bucket → CodePipeline → CodeBuild → Lambda Validation → Deploy
                       ↓
                  CloudWatch Logs
                       ↓
                  SNS Notifications
```

## 🚀 Quick Deploy

```bash
aws cloudformation create-stack \
  --stack-name cicd-pipeline-stack \
  --template-body file://TapStack.yml \
  --capabilities CAPABILITY_IAM \
  --region us-west-2
```

## 📊 Cost

**Monthly**: $30-40 (pay per build)
- CodePipeline: $1/month
- CodeBuild: ~$0.01/minute
- S3: ~$1/month
- Lambda: Minimal
- SNS: ~$0.50/month

## ✨ Features

- ✅ Automated builds on code upload
- ✅ Parallel test execution
- ✅ Custom Lambda validations
- ✅ SNS notifications
- ✅ CloudWatch monitoring
- ✅ Artifact storage
- ✅ Build caching

## 🎯 Use Cases

- Continuous Integration
- Automated Testing
- Deployment Automation
- Code Quality Gates
- Multi-stage Pipelines

## 📚 Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Pipeline design
- [DEPLOYMENT.md](DEPLOYMENT.md) - Setup guide
- [docs/BEST_PRACTICES.md](docs/BEST_PRACTICES.md) - CI/CD tips

## 👤 Author

**Rahul Ladumor** | [@rahulladumor](https://github.com/rahulladumor)

## 📄 License

MIT License

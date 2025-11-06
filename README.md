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

### High-Level Architecture

```mermaid
graph LR
    subgraph Developer
        Dev[Developer<br/>Push Code]
        PR[Pull Request]
    end
    
    subgraph Source Control
        CodeCommit[AWS CodeCommit<br/>Git Repository<br/>3 Branches]
        Dev -->|git push| CodeCommit
        PR -->|merge| CodeCommit
    end
    
    subgraph CI/CD Pipeline
        Pipeline[AWS CodePipeline<br/>Orchestration]
        
        CodeCommit -->|Trigger| Pipeline
    end
    
    subgraph Build Stage
        CodeBuild[AWS CodeBuild<br/>Docker Container<br/>Run Tests]
        
        Pipeline -->|Source| CodeBuild
    end
    
    subgraph Artifact Storage
        S3[S3 Bucket<br/>Build Artifacts<br/>Versioned]
        
        CodeBuild -->|Store| S3
    end
    
    subgraph Deploy Stage
        CodeDeploy[AWS CodeDeploy<br/>Blue/Green Deploy]
        
        S3 -->|Retrieve| CodeDeploy
    end
    
    subgraph Environments
        Dev [Development<br/>Auto-Deploy]
        Staging[Staging<br/>Manual Approval]
        Prod[Production<br/>Manual Approval]
        
        CodeDeploy -->|Deploy| DevEnv
        CodeDeploy -->|Approval| Staging
        CodeDeploy -->|Approval| Prod
    end
    
    subgraph Notifications
        SNS[SNS Topic<br/>Email/Slack]
        
        Pipeline -->|Success/Failure| SNS
        Staging -->|Approval Request| SNS
        Prod -->|Approval Request| SNS
    end
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

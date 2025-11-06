# 🏗️ CI/CD Pipeline Architecture

## Design

**Event-Driven Pipeline**:
1. Code uploaded to S3
2. CodePipeline triggered automatically
3. CodeBuild compiles and tests
4. Lambda validates build
5. SNS notifies team

## Components

### CodePipeline
- Orchestrates workflow
- Manages stages
- Triggers on S3 changes

### CodeBuild
- Compiles code
- Runs tests
- Creates artifacts
- Cached for speed

### Lambda
- Custom validations
- Quality gates
- Integration tests

### CloudWatch
- Build logs
- Pipeline metrics
- Alerts

## Key Decisions

**Why CodePipeline?**
- AWS-native
- No servers
- Pay per pipeline
- Integrates everything

**Why CodeBuild?**
- Serverless
- Any language
- Docker support
- Pay per minute

**Why Lambda for Validation?**
- Custom logic
- Fast execution
- Minimal cost

## Cost Optimization

- Use build caching
- Parallel stages
- Small compute types
- Scheduled builds

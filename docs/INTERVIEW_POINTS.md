# 🎤 Interview Points

## Summary

"Built fully automated CI/CD pipeline using AWS CodePipeline, CodeBuild, and Lambda. Triggers on code uploads, runs tests, validates builds, and notifies team. Serverless architecture costs $30-40/month and scales automatically."

## Key Decisions

**Why CodePipeline?**
- AWS-native integration
- No servers to manage
- $1/month per pipeline

**Why CodeBuild?**
- Serverless compute
- Pay per minute
- Supports all languages

**Why Lambda for Validation?**
- Custom business logic
- Fast execution
- Minimal cost

## Trade-offs

- AWS-specific (not portable)
- vs Jenkins (self-hosted, more control)
- vs GitHub Actions (simpler, less AWS-native)

## Production Improvements

1. Multi-stage (dev/staging/prod)
2. Approval gates
3. Rollback capability
4. Enhanced monitoring

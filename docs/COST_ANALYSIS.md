# 💰 Cost Analysis

## Monthly Costs

| Service | Cost |
|---------|------|
| CodePipeline | $1 |
| CodeBuild (100 builds) | $10 |
| S3 Storage | $1 |
| Lambda | $0.20 |
| SNS | $0.50 |
| CloudWatch Logs | $2 |
| **Total** | **~$15/month** |

## Per Build

- CodeBuild: ~$0.10 per build (10 min)
- Lambda: < $0.01
- Total: ~$0.11 per build

## Cost Optimization

1. Use caching - Save 50% build time
2. Smaller instance types
3. Parallel stages
4. Scheduled builds only

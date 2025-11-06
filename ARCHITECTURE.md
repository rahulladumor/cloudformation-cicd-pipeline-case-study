# Architecture Diagrams - CI/CD Pipeline Infrastructure

Comprehensive Mermaid diagrams for the automated CI/CD pipeline.

## 1. Complete CI/CD Pipeline Flow

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

## 2. Multi-Environment Deployment Strategy

```mermaid
graph TB
    subgraph Git Repository
        main[main branch<br/>Production Ready]
        staging[staging branch<br/>QA Testing]
        develop[develop branch<br/>Development]
    end
    
    subgraph Pipelines
        PipelineProd[Production Pipeline<br/>Manual Approval]
        PipelineStag[Staging Pipeline<br/>Auto Deploy]
        PipelineDev[Development Pipeline<br/>Auto Deploy]
    end
    
    subgraph AWS Environments
        ProdVPC[Production VPC<br/>10.0.0.0/16]
        StagVPC[Staging VPC<br/>10.1.0.0/16]
        DevVPC[Development VPC<br/>10.2.0.0/16]
    end
    
    subgraph Infrastructure
        ProdEC2[Prod EC2<br/>t3.medium x4<br/>Multi-AZ]
        StagEC2[Staging EC2<br/>t3.small x2<br/>Single-AZ]
        DevEC2[Dev EC2<br/>t2.micro x1<br/>Single-AZ]
    end
    
    develop -->|Commit| PipelineDev
    staging -->|Merge| PipelineStag
    main -->|Release| PipelineProd
    
    PipelineDev --> DevVPC
    PipelineStag --> StagVPC
    PipelineProd --> ProdVPC
    
    DevVPC --> DevEC2
    StagVPC --> StagEC2
    ProdVPC --> ProdEC2
```

## 3. CodePipeline Stages Detail

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant CC as CodeCommit
    participant CP as CodePipeline
    participant CB as CodeBuild
    participant S3 as S3 Artifacts
    participant CD as CodeDeploy
    participant EC2 as EC2 Fleet
    participant SNS as SNS
    participant Ops as Operations Team
    
    Dev->>CC: 1. git push
    CC->>CP: 2. Trigger Pipeline (CloudWatch Events)
    
    Note over CP: Source Stage
    CP->>CC: 3. Download Source Code
    
    Note over CP: Build Stage
    CP->>CB: 4. Start Build Job
    CB->>CB: 5. Run Unit Tests
    CB->>CB: 6. Run Integration Tests
    CB->>CB: 7. Build Application
    CB->>S3: 8. Upload Artifacts
    CB->>CP: 9. Build Complete
    
    Note over CP: Deploy to Dev
    CP->>CD: 10. Deploy to Development
    CD->>EC2: 11. Blue/Green Deployment
    CD->>CP: 12. Deployment Success
    CP->>SNS: 13. Dev Deployment Complete
    
    Note over CP: Manual Approval (Staging)
    CP->>SNS: 14. Request Staging Approval
    SNS->>Ops: 15. Email/Slack Notification
    Ops->>CP: 16. Approve Staging Deployment
    
    Note over CP: Deploy to Staging
    CP->>CD: 17. Deploy to Staging
    CD->>EC2: 18. Blue/Green Deployment
    CD->>CP: 19. Staging Success
    
    Note over CP: Manual Approval (Production)
    CP->>SNS: 20. Request Prod Approval
    SNS->>Ops: 21. Email/Slack Notification
    Ops->>CP: 22. Approve Production Deployment
    
    Note over CP: Deploy to Production
    CP->>CD: 23. Deploy to Production
    CD->>EC2: 24. Blue/Green Deployment
    CD->>CP: 25. Production Success
    CP->>SNS: 26. Pipeline Complete
```

## 4. CodeBuild Build Process

```mermaid
graph TB
    subgraph Trigger
        Commit[Code Commit<br/>Push to Repository]
    end
    
    subgraph CodeBuild Environment
        Docker[Docker Container<br/>Amazon Linux 2<br/>4 vCPU, 8GB RAM]
        
        Phase1[Install Phase<br/>Install Dependencies<br/>npm install / pip install]
        Phase2[Pre-Build Phase<br/>Setup Environment<br/>Configure Settings]
        Phase3[Build Phase<br/>Compile Code<br/>Run Tests]
        Phase4[Post-Build Phase<br/>Create Artifacts<br/>Package Application]
    end
    
    subgraph Testing
        Unit[Unit Tests<br/>Jest / PyTest]
        Integration[Integration Tests<br/>API Tests]
        Security[Security Scan<br/>SAST Tools]
        Quality[Code Quality<br/>SonarQube]
    end
    
    subgraph Artifacts
        Zip[Application Package<br/>.zip or .tar.gz]
        Reports[Test Reports<br/>JUnit XML]
        Logs[Build Logs<br/>CloudWatch Logs]
    end
    
    Commit --> Docker
    Docker --> Phase1
    Phase1 --> Phase2
    Phase2 --> Phase3
    Phase3 --> Phase4
    
    Phase3 --> Unit
    Phase3 --> Integration
    Phase3 --> Security
    Phase3 --> Quality
    
    Phase4 --> Zip
    Phase4 --> Reports
    Phase4 --> Logs
    
    Zip --> S3
    Reports --> S3
    Logs --> CloudWatch
```

## 5. Blue/Green Deployment Strategy

```mermaid
graph TB
    subgraph Load Balancer
        ALB[Application<br/>Load Balancer]
        TG1[Target Group BLUE<br/>Production Traffic]
        TG2[Target Group GREEN<br/>New Version]
    end
    
    subgraph Blue Environment - Current
        Blue1[EC2 Instance 1<br/>App v1.0<br/>✅ Healthy]
        Blue2[EC2 Instance 2<br/>App v1.0<br/>✅ Healthy]
        Blue3[EC2 Instance 3<br/>App v1.0<br/>✅ Healthy]
    end
    
    subgraph Green Environment - New
        Green1[EC2 Instance 1<br/>App v2.0<br/>⏳ Testing]
        Green2[EC2 Instance 2<br/>App v2.0<br/>⏳ Testing]
        Green3[EC2 Instance 3<br/>App v2.0<br/>⏳ Testing]
    end
    
    subgraph Deployment Process
        Deploy[CodeDeploy]
        Test[Run Health Checks<br/>Validate New Version]
        Switch[Traffic Switch<br/>100% to GREEN]
        Rollback[Rollback Option<br/>Switch to BLUE]
    end
    
    ALB --> TG1
    ALB -.->|After Switch| TG2
    
    TG1 --> Blue1
    TG1 --> Blue2
    TG1 --> Blue3
    
    TG2 -.-> Green1
    TG2 -.-> Green2
    TG2 -.-> Green3
    
    Deploy --> Green1
    Deploy --> Green2
    Deploy --> Green3
    
    Green1 --> Test
    Test -->|Success| Switch
    Test -->|Failure| Rollback
    
    Switch --> ALB
    Rollback --> TG1
```

## 6. Pipeline Monitoring & Observability

```mermaid
graph LR
    subgraph Pipeline Events
        Start[Pipeline Started]
        Build[Build Stage]
        Test[Test Stage]
        Deploy[Deploy Stage]
        Complete[Pipeline Complete]
        Failed[Pipeline Failed]
    end
    
    subgraph Monitoring
        CW[CloudWatch<br/>Metrics & Logs]
        Dashboard[CloudWatch Dashboard<br/>Real-time View]
        Alarms[CloudWatch Alarms<br/>Failure Alerts]
    end
    
    subgraph Metrics
        Duration[Pipeline Duration<br/>Execution Time]
        Success[Success Rate<br/>Last 30 Days]
        BuildTime[Build Time<br/>Per Stage]
        DeployTime[Deployment Time<br/>Per Environment]
    end
    
    subgraph Notifications
        SNS[SNS Topic]
        Email[Email Alerts]
        Slack[Slack Webhooks]
        PagerDuty[PagerDuty<br/>Critical Failures]
    end
    
    Start --> CW
    Build --> CW
    Test --> CW
    Deploy --> CW
    Complete --> CW
    Failed --> CW
    
    CW --> Dashboard
    CW --> Alarms
    
    CW --> Duration
    CW --> Success
    CW --> BuildTime
    CW --> DeployTime
    
    Alarms --> SNS
    SNS --> Email
    SNS --> Slack
    Alarms --> PagerDuty
```

## 7. Approval Process Flow

```mermaid
sequenceDiagram
    participant Pipeline as CodePipeline
    participant SNS as SNS Topic
    participant Email as Email/Slack
    participant Approver as Approver
    participant Lambda as Approval Lambda
    participant Deploy as CodeDeploy
    
    Note over Pipeline: Dev Deployment Complete
    
    Pipeline->>SNS: 1. Request Staging Approval
    SNS->>Email: 2. Send Notification with Link
    Email->>Approver: 3. Display Approval Request
    
    Note over Approver: Reviews:<br/>- Test Results<br/>- Change Log<br/>- Risk Assessment
    
    alt Approve
        Approver->>Lambda: 4a. Click Approve
        Lambda->>Pipeline: 5a. Approval Granted
        Pipeline->>Deploy: 6a. Start Deployment
        Deploy->>Pipeline: 7a. Deployment Success
        Pipeline->>SNS: 8a. Staging Deployed
    else Reject
        Approver->>Lambda: 4b. Click Reject
        Lambda->>Pipeline: 5b. Approval Denied
        Pipeline->>SNS: 6b. Pipeline Stopped
    end
    
    Note over Pipeline: Same process repeats for Production
```

## 8. Security & Compliance in Pipeline

```mermaid
graph TB
    subgraph Security Checks
        SAST[SAST Scan<br/>Static Analysis<br/>SonarQube/CodeGuru]
        DAST[DAST Scan<br/>Dynamic Testing<br/>OWASP ZAP]
        Secrets[Secrets Scan<br/>Git-Secrets<br/>TruffleHog]
        Dependencies[Dependency Check<br/>Known Vulnerabilities<br/>npm audit]
    end
    
    subgraph Build Pipeline
        Source[Source Code]
        Build[Build Stage]
        Test[Test Stage]
        Package[Package Stage]
    end
    
    subgraph Compliance Gates
        Gate1[Security Gate<br/>No HIGH Severity]
        Gate2[Quality Gate<br/>Code Coverage >80%]
        Gate3[Test Gate<br/>All Tests Pass]
    end
    
    subgraph Actions
        Pass[Deploy to Next Stage]
        Fail[Block Deployment<br/>Notify Team]
    end
    
    Source --> SAST
    Source --> Secrets
    Build --> Dependencies
    Test --> DAST
    
    SAST --> Gate1
    Dependencies --> Gate1
    DAST --> Gate1
    Test --> Gate2
    Test --> Gate3
    
    Gate1 -->|Pass| Pass
    Gate2 -->|Pass| Pass
    Gate3 -->|Pass| Pass
    
    Gate1 -->|Fail| Fail
    Gate2 -->|Fail| Fail
    Gate3 -->|Fail| Fail
```

## 9. Rollback Mechanism

```mermaid
graph TB
    subgraph Production
        Current[Current Version<br/>v1.5<br/>✅ Stable]
        New[New Version<br/>v1.6<br/>⚠️ Issues Detected]
    end
    
    subgraph Monitoring
        Health[Health Checks<br/>Every 30s]
        Metrics[CloudWatch Metrics<br/>Error Rate, Latency]
        Alarms[CloudWatch Alarms<br/>Error Threshold Exceeded]
    end
    
    subgraph Rollback Decision
        Auto[Automatic Rollback<br/>Error Rate >5%<br/>Latency >1s]
        Manual[Manual Rollback<br/>Team Decision]
    end
    
    subgraph Rollback Process
        Stop[Stop New Deployments]
        Switch[Switch Traffic to Blue]
        Restore[Restore Previous Version]
        Notify[Notify Team<br/>Rollback Complete]
    end
    
    New --> Health
    New --> Metrics
    
    Health -->|Failed| Alarms
    Metrics -->|Threshold| Alarms
    
    Alarms --> Auto
    Team --> Manual
    
    Auto --> Stop
    Manual --> Stop
    
    Stop --> Switch
    Switch --> Restore
    Restore --> Notify
    Restore --> Current
```

## 10. Cost Optimization in CI/CD

```mermaid
pie title Monthly CI/CD Cost Breakdown
    "CodeBuild (100 builds/month)" : 10
    "CodePipeline (3 pipelines)" : 3
    "S3 Artifacts Storage" : 5
    "CodeDeploy" : 0
    "CodeCommit Repositories" : 1
    "CloudWatch Logs" : 1
```

```mermaid
graph LR
    subgraph Cost Savings
        Spot[EC2 Spot Instances<br/>Dev/Staging<br/>70% Savings]
        Cache[Build Cache<br/>Docker Layers<br/>40% Faster]
        Parallel[Parallel Builds<br/>Multiple Branches<br/>50% Time Saved]
        Cleanup[Auto Cleanup<br/>Old Artifacts<br/>S3 Lifecycle]
    end
    
    subgraph Best Practices
        Small[Small Build Instances<br/>Right-sizing]
        Short[Short-lived Environments<br/>Auto-terminate]
        Regional[Single Region<br/>Minimize Transfer Costs]
    end
    
    Spot --> Small
    Cache --> Short
    Parallel --> Regional
    Cleanup --> Small
```

---

## Key Features

### 1. Automated Pipeline
- Source: AWS CodeCommit
- Build: AWS CodeBuild
- Deploy: AWS CodeDeploy
- Orchestration: AWS CodePipeline

### 2. Multi-Environment
- Development: Auto-deploy
- Staging: Manual approval
- Production: Manual approval

### 3. Blue/Green Deployment
- Zero-downtime deployments
- Instant rollback capability
- Health check validation

### 4. Security
- SAST/DAST scanning
- Dependency vulnerability checks
- Secrets detection
- Compliance gates

### 5. Monitoring
- CloudWatch metrics
- Real-time dashboards
- SNS notifications
- PagerDuty integration

---

**Author**: Rahul Ladumor  
**License**: MIT 2025

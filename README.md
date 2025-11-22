# 🚀 Automated Cloud-Native CI/CD Pipeline

## 🏗️ Architecture
```mermaid
graph LR
    User[Developer] -- Pushes Code --> GitHub[GitHub Repo]
    GitHub -- Triggers Webhook --> Jenkins[Jenkins Pipeline]
    
    subgraph CI_CD_Pipeline [Jenkins Server]
        Jenkins -- 1. Build --> Docker[Docker Build]
        Docker -- 2. Test --> Test[Unit Tests]
        Test -- 3. Push --> ECR[AWS ECR Registry]
    end
    
    subgraph Infrastructure [AWS Cloud]
        Terraform[Terraform] -- Provisions --> EC2[EC2 Instance]
        Terraform -- Provisions --> SG[Security Group]
        EC2 -- Pulls Image --> ECR
    end
    
    User -- Accesses App --> EC2



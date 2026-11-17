# 部署指南

## 前置条件

- 华为云账号（需完成实名认证）
- 已开通服务：
  - APIG
  - FunctionGraph
  - IAM
  - VPC
  - GaussDB-Mongo
  - VPC 端点

## 部署步骤

### 1. 环境准备

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
export HW_REGION_NAME="cn-north-4"
```

### 2. 部署 Provider 账户

```bash
cd infra
terraform init
terraform apply -var="account_type=provider"
```

### 3. 部署 Consumer 账户

```bash
terraform apply -var="account_type=consumer" -var="provider_account_id=xxx"
```

## 清理

```bash
terraform destroy
```

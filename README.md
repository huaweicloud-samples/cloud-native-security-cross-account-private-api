# cloud-native-security-cross-account-private-api

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)
![Huawei Cloud](https://img.shields.io/badge/%E5%8D%8E%E4%B8%BA%E4%BA%91-%E6%9C%80%E4%BD%B3%E5%AE%9E%E8%B7%B5-ff4d00.svg)

> A cross-account private API communication solution based on Huawei Cloud.

> [中文](README.cn.md)

---

## Overview

This project provides a **cross-account private API communication solution** on Huawei Cloud. It enables private API calls between two independent accounts through APIG without requiring internet gateway, NAT gateway, or VPC peering.

### Core Features

1. **Cross-Account Private Communication**
   - Private connection via VPC endpoints
   - No public network exposure

2. **IAM Role Authentication**
   - Signature-based identity verification
   - Supports role assumption

3. **Private API Configuration**
   - APIG private endpoints
   - Resource policy control

---

## Architecture

```
┌─────────────────────┐         ┌─────────────────────┐
│   Consumer Account  │         │   Provider Account │
│                     │         │                     │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │  Function   │───┼─────────┼───│   Function   │   │
│  │  Graph      │   │         │   │   Graph      │   │
│  └─────────────┘   │         │   └─────────────┘   │
│         │           │         │         │           │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │ IAM Role    │   │         │   │    APIG     │   │
│  │ (Assume)    │   │         │   │  (Private) │   │
│  └─────────────┘   │         │   └─────────────┘   │
│         │           │         │         │           │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │VPC Endpoint │───┼─────────┼───│GaussDB-Mongo│   │
│  └─────────────┘   │         │   └─────────────┘   │
└─────────────────────┘         └─────────────────────┘
```

---

## Key Features

- **Private Connection**: Cross-account private communication via VPC endpoints
- **Serverless**: Uses FunctionGraph, pay-per-use
- **Secure Authentication**: IAM role and signature verification
- **Private API**: APIG private endpoint configuration

---

## Prerequisites

- Huawei Cloud account (real-name authentication required)
- Services enabled: APIG, FunctionGraph, IAM, VPC, GaussDB-Mongo

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/huaweicloud-samples/cloud-native-security-cross-account-private-api.git
cd cloud-native-security-cross-account-private-api
```

### 2. Configure Credentials

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
export HW_REGION_NAME="cn-north-4"
```

### 3. Deploy

```bash
cd infra
terraform init
terraform apply
```

---

## Usage

### Call Private API

```bash
# Consumer call
curl -X GET https://<private-api-endpoint>/resource \
  -H "Authorization: Bearer <token>"
```

---

## Cleanup

```bash
terraform destroy
```

---

## License

MIT No Attribution - See [LICENSE](LICENSE) file for details

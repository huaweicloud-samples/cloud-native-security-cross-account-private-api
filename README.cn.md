# cloud-native-security-cross-account-private-api

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)
![Huawei Cloud](https://img.shields.io/badge/%E5%8D%8E%E4%B8%BA%E4%BA%91-%E6%9C%80%E4%BD%B3%E5%AE%9E%E8%B7%B5-ff4d00.svg)

> 基于华为云的跨账户私有 API 通信解决方案。

> [English](README.md)

---

## 简介

本项目提供基于华为云的**跨账户私有 API 通信**解决方案，通过 APIG 实现两个独立账户之间的私有 API 调用，无需互联网网关、NAT 网关或 VPC 对等连接。

### 核心功能

1. **跨账户私有通信**
   - 通过 VPC 端点实现私有连接
   - 无需公网暴露

2. **IAM 角色认证**
   - 基于签名的身份验证
   - 支持角色扮演

3. **私有 API 配置**
   - APIG 私有端点
   - 资源策略控制

---

## 架构

```
┌─────────────────────┐         ┌─────────────────────┐
│   消费方账户        │         │   提供方账户        │
│                     │         │                     │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │  Function   │───┼─────────┼───│   Function   │   │
│  │  Graph      │   │         │   │   Graph      │   │
│  └─────────────┘   │         │   └─────────────┘   │
│         │           │         │         │           │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │ IAM Role    │   │         │   │    APIG     │   │
│  │ (Assume)    │   │         │   │  (私有)    │   │
│  └─────────────┘   │         │   └─────────────┘   │
│         │           │         │         │           │
│  ┌─────────────┐   │         │   ┌─────────────┐   │
│  │VPC Endpoint │───┼─────────┼───│GaussDB-Mongo│   │
│  └─────────────┘   │         │   └─────────────┘   │
└─────────────────────┘         └─────────────────────┘
```

---

## 核心特点

- **私有连接**: 通过 VPC 端点实现跨账户私有通信
- **无服务器**: 使用 FunctionGraph，按调用量结算
- **安全认证**: IAM 角色与签名验证
- **私有 API**: APIG 私有端点配置

---

## 前置条件

- 华为云账号（需完成实名认证）
- 已开通服务：APIG、FunctionGraph、IAM、VPC、GaussDB-Mongo

---

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/huaweicloud-samples/cloud-native-security-cross-account-private-api.git
cd cloud-native-security-cross-account-private-api
```

### 2. 配置凭证

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
export HW_REGION_NAME="cn-north-4"
```

### 3. 部署

```bash
cd infra
terraform init
terraform apply
```

---

## 使用方法

### 调用私有 API

```bash
# 消费方调用
curl -X GET https://<private-api-endpoint>/resource \
  -H "Authorization: Bearer <token>"
```

---

## 清理资源

```bash
terraform destroy
```

---

## 许可证

MIT No Attribution - 详见 [LICENSE](LICENSE) 文件

# Terraform 配置 - 华为云跨账户私有 API

terraform {
  required_version = ">= 1.0"
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
    }
  }
}

provider "huaweicloud" {
  region = var.region
}

# VPC (Provider)
resource "huaweicloud_vpc" "provider" {
  name = "provider-vpc"
  cidr = "10.1.0.0/16"
}

resource "huaweicloud_vpc_subnet" "provider" {
  name       = "provider-subnet"
  vpc_id     = huaweicloud_vpc.provider.id
  cidr       = "10.1.1.0/24"
  gateway_ip = "10.1.1.1"
}

# 安全组
resource "huaweicloud_networking_secgroup" "provider" {
  name        = "provider-sg"
  description = "Security group for provider"
}

# GaussDB-Mongo
resource "huaweicloud_gaussdb_mongo_instance" "main" {
  name              = "private-api-mongo"
  flavor            = "gaussdb.mongo.4xlarge.4"
  volume_size       = 20
  vpc_id            = huaweicloud_vpc.provider.id
  subnet_id         = huaweicloud_vpc_subnet.provider.id
  security_group_id = huaweicloud_networking_secgroup.provider.id
  availability_zone = var.availability_zone
}

# FunctionGraph - Backend
resource "huaweicloud_fgs_function" "backend" {
  name        = "private-api-backend"
  runtime     = "Python3.9"
  handler     = "index.handler"
  memory_size = 512
  timeout     = 30

  app = "default"

  func_code = filebase64("${path.module}/../src/backend.zip")
}

# APIG 实例
resource "huaweicloud_apig_instance" "main" {
  name              = "private-api-apig"
  flavor            = "BASIC"
  vpc_id            = huaweicloud_vpc.provider.id
  subnet_id         = huaweicloud_vpc_subnet.provider.id
  available_zones   = [var.availability_zone]
  security_group_id = huaweicloud_networking_secgroup.provider.id
}

# APIG API
resource "huaweicloud_apig_api" "resource" {
  name         = "private-resource"
  gateway_id   = huaweicloud_apig_instance.main.id
  path         = "/resource"
  method       = "GET"
  function_urn = huaweicloud_fgs_function.backend.urn
}

resource "huaweicloud_apig_api_publishment" "resource" {
  api_id = huaweicloud_apig_api.resource.id
  env_id = "release"
}

# IAM 角色 (跨账户)
resource "huaweicloud_iam_role" "cross_account" {
  name        = "cross-account-api-role"
  description = "Cross account API role"
  domain_id   = var.provider_domain_id

  trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Account = var.consumer_account_id
      }
      Action = ["sts:AssumeRole"]
    }]
  })
}

# VPC 端点
resource "huaweicloud_vpc_endpoint" "apig" {
  service_name = "apig.cn-north-4.myhuaweicloud.com"
  vpc_id       = huaweicloud_vpc.provider.id
  subnet_ids   = [huaweicloud_vpc_subnet.provider.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["apig:Invoke"]
      Resource = "*"
    }]
  })
}

# 输出
output "api_endpoint" {
  value = "https://${huaweicloud_apig_instance.main.endpoint}/resource"
}

output "role_arn" {
  value = huaweicloud_iam_role.cross_account.arn
}

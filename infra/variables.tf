variable "region" {
  description = "华为云区域"
  type        = string
  default     = "cn-north-4"
}

variable "availability_zone" {
  description = "可用区"
  type        = string
  default     = "cn-north-4a"
}

variable "provider_domain_id" {
  description = "提供方账户域名ID"
  type        = string
  default     = ""
}

variable "consumer_account_id" {
  description = "消费方账户ID"
  type        = string
  default     = ""
}

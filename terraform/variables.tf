variable "project" {
  default = "finops-practice"
}

variable "region" {
  default = "us-central1"
}

variable "slack_webhook_url" {
  description = "Slack incoming webhook URL for alerts"
  type        = string
  sensitive   = true
}

variable "email_sender" {
  description = "Alert email sender address"
  type        = string
}

variable "email_recipient" {
  description = "Alert email recipient address"
  type        = string
}


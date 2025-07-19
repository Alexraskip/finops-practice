variable "project" {
  description = "The GCP project ID"
  type        = string
  default     = "finops-practice"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "transfer_service_account" {
  description = "Service account email to run BigQuery scheduled queries"
  type        = string
}

variable "email_sender" {
  description = "Email address that sends alert emails"
  type        = string
}

variable "email_recipient" {
  description = "Email address that receives alert emails"
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack incoming webhook URL for alerts"
  type        = string
  sensitive   = true
}

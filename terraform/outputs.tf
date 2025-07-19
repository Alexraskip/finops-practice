output "project" {
  description = "The GCP project ID used for this deployment"
  value       = var.project
}

output "region" {
  description = "The GCP region where resources are deployed"
  value       = var.region
}

output "transfer_service_account" {
  description = "The service account running scheduled BigQuery queries"
  value       = var.transfer_service_account
  sensitive   = true
}

output "alert_email_sender" {
  description = "Sender email for alerting"
  value       = var.email_sender
  sensitive   = true
}

output "alert_email_recipient" {
  description = "Recipient email for alerting"
  value       = var.email_recipient
  sensitive   = true
}

output "slack_webhook_url" {
  description = "Slack webhook URL used for alerts (masked)"
  value       = length(var.slack_webhook_url) > 0 ? "***********" : ""
  sensitive   = true
}

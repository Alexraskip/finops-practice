resource "google_bigquery_data_transfer_config" "forecasting" {
  display_name           = "Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "first day of month 00:01"  # Monthly at 00:01 on the 1st day
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/forecasting.sql")
    destination_table_name_template = "monthly_forecast"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "anomaly_detection" {
  display_name           = "Anomaly Detection"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"  # Daily
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/anomaly_detection.sql")
    destination_table_name_template = "anomaly_report"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "budgeting_alerts" {
  display_name           = "Budgeting Alerts"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/budgeting_alerts.sql")
    destination_table_name_template = "budgeting_alerts"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "cost_threshold_alerts" {
  display_name           = "Cost Thresholds Alerts"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/cost_threshold_alerts.sql")
    destination_table_name_template = "cost_threshold_alerts"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "cost_visibility" {
  display_name           = "Cost Visibility"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/cost_visibility.sql")
    destination_table_name_template = "cost_visibility"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "pricing_optimization" {
  display_name           = "Pricing Optimization"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/pricing_optimization.sql")
    destination_table_name_template = "pricing_optimization"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "rightsizing" {
  display_name           = "Rightsizing"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/rightsizing.sql")
    destination_table_name_template = "rightsizing"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "tagging_coverage" {
  display_name           = "Tagging Coverage"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/tagging_coverage.sql")
    destination_table_name_template = "tagging_coverage"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "trend_forecast" {
  display_name           = "Trend Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/trend_forecast.sql")
    destination_table_name_template = "trend_forecast"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

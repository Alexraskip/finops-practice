resource "google_bigquery_data_transfer_config" "monthly_forecast" {
  display_name = "Monthly Cost Forecast"
  data_source_id = "scheduled_query"
  schedule = "every 1 month"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id

  params = {
    query = file("${path.module}/../queries/forecasting.sql")
    destination_table_name_template = "monthly_forecast"
    write_disposition = "WRITE_TRUNCATE"
  }
}

resource "google_bigquery_data_transfer_config" "anomaly_detection" {
  display_name = "Anomaly Detection"
  data_source_id = "scheduled_query"
  schedule = "every 1 day"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id

  params = {
    query = file("${path.module}/../queries/anomaly_detection.sql")
    destination_table_name_template = "anomaly_report"
    write_disposition = "WRITE_TRUNCATE"
  }
}

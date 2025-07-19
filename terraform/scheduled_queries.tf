# Monthly forecast
resource "google_bigquery_data_transfer_config" "monthly_cost_forecast" {
  display_name           = "Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "first day of month 00:01"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/monthly_cost_forecast.sql")
    destination_table_name_template = "monthly_cost_forecast"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# Anomaly detection (daily)
resource "google_bigquery_data_transfer_config" "anomaly_detection" {
  display_name           = "Anomaly Detection"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
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

# Budgeting alerts (daily)
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

# Cost threshold alerts (daily)
resource "google_bigquery_data_transfer_config" "cost_threshold_alerts" {
  display_name           = "Cost Threshold Alerts"
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

# New cost & optimization queries you added
resource "google_bigquery_data_transfer_config" "spot_savings_estimate" {
  display_name           = "Spot Savings Estimate"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/spot_savings_estimate.sql")
    destination_table_name_template = "spot_savings_estimate"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "spot_vs_on_demand_costs" {
  display_name           = "Spot vs On-Demand Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/spot_vs_on_demand_costs.sql")
    destination_table_name_template = "spot_vs_on_demand_costs"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "tagging_completeness_by_department" {
  display_name           = "Tagging Completeness by Department"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/tagging_completeness_by_department.sql")
    destination_table_name_template = "tagging_completeness_by_department"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "unattached_storage_volumes" {
  display_name           = "Unattached Storage Volumes"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/unattached_storage_volumes.sql")
    destination_table_name_template = "unattached_storage_volumes"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "oversized_resources" {
  display_name           = "Oversized Resources"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/oversized_resources.sql")
    destination_table_name_template = "oversized_resources"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "rightsizing_recommendations" {
  display_name           = "Rightsizing Recommendations"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/rightsizing_recommendations.sql")
    destination_table_name_template = "rightsizing_recommendations"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# Add any other new queries you created (resource_type_env_costs, service_sku_costs, etc.) in the same pattern
resource "google_bigquery_data_transfer_config" "resource_type_env_costs" {
  display_name           = "Resource Type and Environment Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/resource_type_env_costs.sql")
    destination_table_name_template = "resource_type_env_costs"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "service_sku_costs" {
  display_name           = "Service and SKU Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/service_sku_costs.sql")
    destination_table_name_template = "service_sku_costs"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "chargeback_costs" {
  display_name           = "Chargeback Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/chargeback_costs.sql")
    destination_table_name_template = "chargeback_costs"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "Cost_by_Region" {
  display_name           = "Chargeback Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/cost_by_region.sql")
    destination_table_name_template = "cost_by_region"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "Cost_by_Region" {
  display_name           = "Chargeback Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/cost_by_region.sql")
    destination_table_name_template = "cost_by_region"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "department_env_cost_summary" {
  display_name           = "Department & Environment Cost Summary"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"   # Adjust schedule as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                            = file("${path.module}/queries/department_env_costs.sql")
    destination_table_name_template  = "department_env_costs"
    write_disposition                = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "idle_resources" {
  display_name           = "Idle Resources Report"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"  # Run daily; adjust as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/Idle_Resources.sql")
    destination_table_name_template = "idle_resources"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "missing_cost_center_label_by_project" {
  display_name           = "Missing Cost Center Label By Project"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"  # Adjust frequency as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/missing_cost_center_label_by_project.sql")
    destination_table_name_template = "missing_cost_center_by_project"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_monthly_cost_forecast" {
  display_name           = "Project Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "first day of month 00:01"  # Monthly schedule, adjust as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/project_monthly_cost_forecast.sql")
    destination_table_name_template = "project_monthly_cost_forecast"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_monthly_costs" {
  display_name           = "Project Monthly Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"  # Or choose monthly/daily as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/project_monthly_costs.sql")
    destination_table_name_template = "project_monthly_costs"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_service_monthly_forecast" {
  display_name           = "Project Service Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"  # Adjust schedule as needed
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/project_service_monthly_cost_forecast.sql")
    destination_table_name_template = "project_service_monthly_cost_forecast"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}


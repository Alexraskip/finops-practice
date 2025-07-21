# ----------------------------
# Forecast & trend reports
# ----------------------------

resource "google_bigquery_data_transfer_config" "monthly_cost_forecast" {
  # Runs monthly cost forecasting query on first day of each month at 00:01
  display_name           = "Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "first day of month 00:01"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/monthly_cost_forecast.sql")
    destination_table_name_template = "monthly_cost_forecast"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_monthly_cost_forecast" {
  # Forecast costs per project monthly, scheduled monthly
  display_name           = "Project Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "first day of month 00:01"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/project_monthly_cost_forecast.sql")
    destination_table_name_template = "project_monthly_cost_forecast"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_service_monthly_forecast" {
  # Forecast costs per project and service daily
  display_name           = "Project Service Monthly Cost Forecast"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/project_service_monthly_cost_forecast.sql")
    destination_table_name_template = "project_service_monthly_cost_forecast"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Alerts & anomaly detection
# ----------------------------

resource "google_bigquery_data_transfer_config" "anomaly_detection" {
  # Detects anomalies in cost data daily
  display_name           = "Anomaly Detection"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/anomaly_detection.sql")
    destination_table_name_template = "anomaly_report"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "budgeting_alerts" {
  # Alerts when costs exceed budgets daily
  display_name           = "Budgeting Alerts"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/budgeting_alerts.sql")
    destination_table_name_template = "budgeting_alerts"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "cost_threshold_alerts" {
  # Alerts for cost thresholds exceeded daily
  display_name           = "Cost Threshold Alerts"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/cost_threshold_alerts.sql")
    destination_table_name_template = "cost_threshold_alerts"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Cost optimization & hygiene
# ----------------------------

resource "google_bigquery_data_transfer_config" "idle_resources" {
  # Identifies idle resources daily
  display_name           = "Idle Resources"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/idle_resources.sql")
    destination_table_name_template = "idle_resources"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "oversized_resources" {
  # Identifies oversized resources daily
  display_name           = "Oversized Resources"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/oversized_resources.sql")
    destination_table_name_template = "oversized_resources"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "rightsizing_recommendations" {
  # Provides rightsizing recommendations daily
  display_name           = "Rightsizing Recommendations"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/rightsizing_recommendations.sql")
    destination_table_name_template = "rightsizing_recommendations"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Spot & pricing analysis
# ----------------------------

resource "google_bigquery_data_transfer_config" "spot_savings_estimate" {
  # Estimates savings using spot pricing daily
  display_name           = "Spot Savings Estimate"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/spot_savings_estimate.sql")
    destination_table_name_template = "spot_savings_estimate"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "spot_vs_on_demand_costs" {
  # Compares spot vs on-demand costs daily
  display_name           = "Spot vs On-Demand Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/spot_vs_on_demand_costs.sql")
    destination_table_name_template = "spot_vs_on_demand_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Tagging & cost center
# ----------------------------

resource "google_bigquery_data_transfer_config" "tagging_completeness_by_department" {
  # Checks tagging completeness per department daily
  display_name           = "Tagging Completeness by Department"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/tagging_completeness_by_department.sql")
    destination_table_name_template = "tagging_completeness_by_department"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "missing_cost_center_label_by_project" {
  # Identifies projects missing cost center labels daily
  display_name           = "Missing Cost Center Label By Project"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/missing_cost_center_label_by_project.sql")
    destination_table_name_template = "missing_cost_center_by_project"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Department, region & project cost summaries
# ----------------------------

resource "google_bigquery_data_transfer_config" "chargeback_costs" {
  # Provides chargeback cost summaries daily
  display_name           = "Chargeback Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/chargeback_costs.sql")
    destination_table_name_template = "chargeback_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "cost_by_region" {
  # Summarizes costs by region daily
  display_name           = "Cost by Region"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/cost_by_region.sql")
    destination_table_name_template = "cost_by_region"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "department_env_cost_summary" {
  # Summarizes costs by department and environment daily
  display_name           = "Department & Environment Cost Summary"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/department_env_costs.sql")
    destination_table_name_template = "department_env_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "project_monthly_costs" {
  # Provides monthly cost summaries per project daily
  display_name           = "Project Monthly Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/project_monthly_costs.sql")
    destination_table_name_template = "project_monthly_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Extra breakdowns
# ----------------------------

resource "google_bigquery_data_transfer_config" "resource_type_env_costs" {
  # Summarizes costs by resource type and environment daily
  display_name           = "Resource Type & Environment Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/resource_type_env_costs.sql")
    destination_table_name_template = "resource_type_env_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "service_sku_costs" {
  # Summarizes costs by service and SKU daily
  display_name           = "Service & SKU Costs"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query  = file("${path.module}/queries/service_sku_costs.sql")
    destination_table_name_template = "service_sku_costs"
    write_disposition = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

# ----------------------------
# Custom cost hygiene queries
# ----------------------------

resource "google_bigquery_data_transfer_config" "unattached_storage_volumes" {
  # Identifies unattached storage volumes daily
  display_name           = "Unattached Storage Volumes"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/unattached_storage_volumes.sql")
    destination_table_name_template = "unattached_unused_storage_volumes"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

resource "google_bigquery_data_transfer_config" "underutilized_resources" {
  # Identifies underutilized resources daily
  display_name           = "Underutilized Resources"
  data_source_id         = "scheduled_query"
  schedule               = "every 24 hours"
  destination_dataset_id = google_bigquery_dataset.billing_data.dataset_id
  service_account_name   = var.transfer_service_account

  params = {
    query                           = file("${path.module}/queries/underutilized_resources.sql")
    destination_table_name_template = "underutilized_resources"
    write_disposition               = "WRITE_TRUNCATE"
  }

  project  = var.project
  location = "US"
}

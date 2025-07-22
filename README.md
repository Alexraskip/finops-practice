📄 README.md
markdown
Copy
Edit
# 🏷️ FinOps Practice on Google Cloud (with Terraform, Python & BigQuery)

> Practice large-scale cloud cost management by simulating thousands of projects & multiple billing accounts.  
> Tools: Python, Terraform, BigQuery, Google Cloud SDK, VS Code.

---

## ✅ **Project structure**
finops-practice/
├── data/
│ └── synthetic_gcp_billing_export.csv
├── scripts/
│ ├── generate_synthetic_gcp_billing.py
│ ├── upload_to_bigquery.ps1
│ └── queries.sql
├── terraform/
│ └── main.tf
└── README.md

yaml
Copy
Edit

---

## ⚙ **Step 1: Environment setup**

### 1. Install tools
- Terraform (Windows binary, added to PATH or run with full path)
- Google Cloud SDK  
- VS Code + extensions:
  - Terraform
  - Python
  - Google Cloud Tools
  - Cloud Code
  - BigQuery Language Support

### 2. Authenticate & set project
```powershell
gcloud init
gcloud auth application-default login --scopes=https://www.googleapis.com/auth/cloud-platform
gcloud config set project finops-practice
🐍 Step 2: Generate synthetic billing data
Script: scripts/generate_synthetic_gcp_billing.py
Generates synthetic CSV with ~3000 projects x 30 days:

powershell
Copy
Edit
cd scripts
python generate_synthetic_gcp_billing.py
Output:

Copy
Edit
synthetic_gcp_billing_export.csv
☁ Step 3: Create BigQuery dataset with Terraform
Terraform provider config in terraform/main.tf:
hcl
Copy
Edit
provider "google" {
  project = "finops-practice"
  region  = "us-central1"
}

resource "google_bigquery_dataset" "billing_data" {
  dataset_id                 = "billing_data"
  description                = "Synthetic billing data for FinOps practice"
  location                   = "US"
  delete_contents_on_destroy = true
}
Initialize & apply:
powershell
Copy
Edit
cd terraform
& "D:\CCC 2025 DATA\Important Files\Jose\tools\terraform\terraform.exe" validate
& "D:\CCC 2025 DATA\Important Files\Jose\tools\terraform\terraform.exe" init
& "D:\CCC 2025 DATA\Important Files\Jose\tools\terraform\terraform.exe" apply
📥 Step 4: Upload CSV to BigQuery
Script: scripts/upload_to_bigquery.ps1
powershell
Copy
Edit
cd scripts
.\upload_to_bigquery.ps1
Contents:

powershell
Copy
Edit
Write-Host "Uploading CSV to BigQuery table..."

bq --location=US load `
--autodetect `
--skip_leading_rows=1 `
--source_format=CSV `
finops-practice:billing_data.exported_billing `
"../data/synthetic_gcp_billing_export.csv"

Write-Host "✅ Upload completed!"
🔍 Step 5: Explore & query
Go to BigQuery Console → Dataset: billing_data

Table: exported_billing

Use queries.sql as starter:

sql
Copy
Edit
SELECT
  project_id,
  SUM(cost) as total_cost
FROM `finops-practice.billing_data.exported_billing`
GROUP BY project_id
ORDER BY total_cost DESC
LIMIT 10
📌 Commands summary used
powershell
Copy
Edit
# GCP auth & config
gcloud init
gcloud auth application-default login --scopes=https://www.googleapis.com/auth/cloud-platform
gcloud config set project finops-practice

# Generate data
python scripts/generate_synthetic_gcp_billing.py

# Terraform
cd terraform
& "D:\CCC 2025 DATA\Important Files\Jose\tools\terraform\terraform.exe" init
& "D:\CCC 2025 DATA\Important Files\Jose\tools\terraform\terraform.exe" apply

# Upload data
cd scripts
.\upload_to_bigquery.ps1


# 📊 FinOps Scheduled Queries

This folder contains production-ready SQL queries used in automated BigQuery scheduled transfers (via Terraform).  
They support cost visibility, forecasting, anomaly detection, and optimization.

---

## ✅ Query list & purpose

| Query file | Destination Table | Purpose |
|-----------|------------------|--------|
| `monthly_cost_forecast.sql` | `monthly_cost_forecast` | Forecast overall monthly cost trends (moving average, next month prediction). |
| `project_monthly_cost_forecast.sql` | `project_monthly_cost_forecast` | Forecast monthly cost per project (moving average + forecast). |
| `project_service_monthly_cost_forecast.sql` | `project_service_monthly_cost_forecast` | Forecast monthly cost per project and service (more granular). |
| `project_monthly_costs.sql` | `project_monthly_costs` | Historical monthly cost per project, with customer and business info. |
| `chargeback_costs.sql` | `chargeback_costs` | Cost breakdown for chargeback: customer, product team, business unit, etc. |
| `department_env_costs.sql` | `department_env_costs` | Cost summary grouped by department and environment (prod, dev, etc.). |
| `cost_by_region.sql` | `cost_by_region` | Cost summary by region to highlight location-specific spend. |
| `resource_type_env_costs.sql` | `resource_type_env_costs` | Cost by resource type and environment to help identify hotspots. |
| `service_sku_costs.sql` | `service_sku_costs` | Detailed cost per service and SKU description. |

---

## 🛡 Optimization & hygiene

| Query file | Destination Table | Purpose |
|-----------|------------------|--------|
| `Idle_Resources.sql` | `idle_resources` | Identify top idle resources (utilization=0) by cost. |
| `oversized_resources.sql` | `oversized_resources` | Detect oversized resources for potential downsizing. |
| `rightsizing_recommendations.sql` | `rightsizing_recommendations` | Generate daily rightsizing recommendations. |
| `spot_savings_estimate.sql` | `spot_savings_estimate` | Estimate savings from moving to spot instances. |
| `spot_vs_on_demand_costs.sql` | `spot_vs_on_demand_costs` | Compare spot vs on-demand cost trends. |

---

## ⚠ Alerts & completeness

| Query file | Destination Table | Purpose |
|-----------|------------------|--------|
| `anomaly_detection.sql` | `anomaly_report` | Identify unusual spikes or drops in cost. |
| `budgeting_alerts.sql` | `budgeting_alerts` | Daily alerts for budget thresholds. |
| `cost_threshold_alerts.sql` | `cost_threshold_alerts` | Alert if daily cost exceeds defined thresholds. |
| `tagging_completeness_by_department.sql` | `tagging_completeness_by_department` | Tagging coverage by department. |
| `missing_cost_center_label_by_project.sql` | `missing_cost_center_by_project` | Top projects missing `cost_center` label (for governance). |

---

## 🛠 How to use
- Each SQL query creates or replaces a summary table in the `billing_data` dataset.
- Queries are automatically scheduled & managed via Terraform.
- Update a query → commit → re-apply Terraform → scheduled job updates automatically.

```bash
terraform fmt
terraform validate
terraform apply

### To indentify unattached persistent disks across large scale environment
Option 1: Cloud Asset Inventory → BigQuery (recommended & easiest for BigQuery users):
Enable Cloud Asset Inventory export to BigQuery
It exports the full list of resources (incl. disks) into a BigQuery table, daily/hourly.
Then, use scheduled queries (BigQuery Scheduler) to join:
asset inventory → check which disks have empty users list (unattached)
billing export → get cost
Step 1: Enable Cloud Asset Inventory export to BigQuery
Step 2: Confirm your billing export exists in BigQuery
Step 3: Write a scheduled BigQuery query to find unattached disks and join costs
Step 4: Schedule this query to run daily
Step 5: Build dashboards or alerts


🚀 Next ideas
✅ Automate daily data generation
✅ Build Looker Studio dashboards
✅ Add cost anomaly detection scripts
✅ Practice with IAM, budgets, and alerts
✅Identify and clean up unattached disks & unused IPs
✅Rightsizing recommendations based on utilization
✅Network tier optimization
✅Storage class analysis & auto-tiering recommendations
✅Budget alerts & quota-based controls
✅Cloud Monitoring dashboards & lightweight Cloud Run reporting app

✨ Author
FinOps Lab — Practice project by [Josphat Too Langat]
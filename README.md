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
🚀 Next ideas
✅ Automate daily data generation
✅ Build Looker Studio dashboards
✅ Add cost anomaly detection scripts
✅ Practice with IAM, budgets, and alerts

✨ Author
FinOps Lab — Practice project by [Josphat Too Langat]
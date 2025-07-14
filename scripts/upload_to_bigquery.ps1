Write-Host "Uploading CSV to BigQuery table..."

bq --location=US load `
  --autodetect `
  --skip_leading_rows=1 `
  --source_format=CSV `
  "finops-practice:billing_data.exported_billing" `
  "..\data\synthetic_gcp_billing_export.csv"

Write-Host "✅ Upload completed!"



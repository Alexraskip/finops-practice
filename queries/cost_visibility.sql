-- Total cost by project and month
SELECT
  project_id,
  invoice_month,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY project_id, invoice_month
ORDER BY invoice_month DESC, total_cost DESC;


-- Cost by department and environment
SELECT
  labels_department,
  environment,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY labels_department, environment
ORDER BY total_cost DESC;


-- Chargeback report (cost by billing account & department)
SELECT
  billing_account_id,
  labels_department,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY billing_account_id, labels_department
ORDER BY total_cost DESC;


-- Showback: Cost split by service and SKU
SELECT
  service_description,
  sku_description,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY service_description, sku_description
ORDER BY total_cost DESC;

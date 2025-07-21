-- Summarize total cost by department, environment, and billing account
-- including business context fields for richer reporting

SELECT
  b.labels_department,                          -- cost allocation label: department
  b.environment,                                -- environment label (e.g., dev, prod)
  r.billing_account_id,                         -- billing account identifier
  r.customer_name,                              -- customer name for context
  r.business_unit,                              -- business unit
  r.product_team,                               -- product team name
  ROUND(SUM(b.cost), 2) AS total_cost           -- total cost per group, rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` b  -- billing export fact table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- enrich with billing account metadata
ON
  b.billing_account_id = r.billing_account_id
GROUP BY
  b.labels_department,                          -- group by department
  b.environment,                                -- group by environment
  r.billing_account_id,                         -- and billing account & metadata fields
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  total_cost DESC;                              -- highest spend groups first

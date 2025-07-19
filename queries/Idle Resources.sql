CREATE OR REPLACE TABLE `finops-practice.billing_data.idle_resources` AS
SELECT
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.service_description,
  b.sku_description,
  b.usage_start_time,
  ROUND(b.cost, 2) AS cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON b.billing_account_id = r.billing_account_id
WHERE
  b.utilization = 0
ORDER BY
  cost DESC
LIMIT 50;

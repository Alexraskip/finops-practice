CREATE OR REPLACE TABLE `finops-practice.billing_data.unattached_storage_volumes` AS
SELECT
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.resource_id,
  b.service_description,
  b.sku_description,
  ROUND(SUM(b.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON b.billing_account_id = r.billing_account_id
WHERE
  b.resource_type = 'Storage Volume'
  AND b.attached = FALSE
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.resource_id,
  b.service_description,
  b.sku_description
ORDER BY total_cost DESC
LIMIT 50;

SELECT
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.service_description,
  b.sku_description,
  ROUND(AVG(b.utilization), 2) AS avg_utilization,
  ROUND(SUM(b.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON b.billing_account_id = r.billing_account_id
WHERE
  b.utilization < 20
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.service_description,
  b.sku_description
ORDER BY
  avg_utilization ASC
LIMIT 50;

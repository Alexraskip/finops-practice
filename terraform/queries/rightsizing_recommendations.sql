WITH usage_summary AS (
  SELECT
    billing_account_id,
    project_id,
    service_description,
    sku_description,
    AVG(utilization) AS avg_utilization,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY billing_account_id, project_id, service_description, sku_description
  HAVING avg_utilization < 50
)
SELECT
  u.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  u.project_id,
  u.service_description,
  u.sku_description,
  ROUND(u.avg_utilization, 2) AS avg_utilization,
  ROUND(u.total_cost, 2) AS total_cost
FROM usage_summary u
LEFT JOIN `finops-practice.billing_data.billing_account_reference` r
  ON u.billing_account_id = r.billing_account_id
ORDER BY total_cost DESC
LIMIT 50

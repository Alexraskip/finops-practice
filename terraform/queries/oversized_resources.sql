CREATE OR REPLACE TABLE `finops-practice.billing_data.oversized_resources` AS
WITH prepared AS (
  SELECT
    billing_account_id,
    project_id,
    sku_description,
    CASE resource_size
      WHEN 'Small' THEN 2
      WHEN 'Medium' THEN 4
      WHEN 'Large' THEN 8
      ELSE 0
    END AS resource_size_num,
    utilization,
    cost
  FROM `finops-practice.billing_data.exported_billing`
)
SELECT
  p.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  p.project_id,
  p.sku_description,
  p.resource_size_num,
  ROUND(AVG(p.utilization), 2) AS avg_utilization,
  ROUND(SUM(p.cost), 2) AS total_cost
FROM prepared p
LEFT JOIN `finops-practice.billing_data.billing_account_reference` r
  ON p.billing_account_id = r.billing_account_id
WHERE
  p.resource_size_num > 4
  AND p.utilization < 30
GROUP BY
  p.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  p.project_id,
  p.sku_description,
  p.resource_size_num
ORDER BY
  total_cost DESC
LIMIT 50;

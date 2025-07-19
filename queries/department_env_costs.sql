CREATE OR REPLACE TABLE `finops-practice.billing_data.department_environment_cost_summary` AS
SELECT
  b.labels_department,
  b.environment,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  ROUND(SUM(b.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  b.billing_account_id = r.billing_account_id
GROUP BY
  b.labels_department,
  b.environment,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  total_cost DESC;

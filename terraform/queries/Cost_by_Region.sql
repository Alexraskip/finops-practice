CREATE OR REPLACE TABLE `finops-practice.billing_data.cost_by_region` AS
SELECT
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.region,
  ROUND(SUM(b.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing.data.billing_account_reference` r
ON b.billing_account_id = r.billing_account_id
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.region
ORDER BY total_cost DESC;

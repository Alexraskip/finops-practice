SELECT
  eb.environment,
  eb.sku_description,
  r.customer_name,
  r.business_unit,
  r.product_team,
  ROUND(SUM(eb.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` eb
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
  ON eb.billing_account_id = r.billing_account_id
GROUP BY
  eb.environment, eb.sku_description, r.customer_name, r.business_unit, r.product_team
ORDER BY
  total_cost DESC

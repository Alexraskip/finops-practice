CREATE OR REPLACE TABLE `finops-practice.billing_data.spot_vs_on_demand_costs` AS
SELECT
  eb.pricing_model,
  ROUND(SUM(eb.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` eb
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  eb.billing_account_id = r.billing_account_id
GROUP BY
  eb.pricing_model
ORDER BY
  total_cost DESC;

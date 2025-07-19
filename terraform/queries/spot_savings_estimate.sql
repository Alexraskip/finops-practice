SELECT
  ROUND(SUM(eb.cost), 2) AS on_demand_cost,
  ROUND(SUM(eb.cost) * 0.3, 2) AS estimated_spot_cost,  -- assuming 70% cheaper
  ROUND(SUM(eb.cost) - SUM(eb.cost) * 0.3, 2) AS potential_savings
FROM
  `finops-practice.billing_data.exported_billing` eb
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  eb.billing_account_id = r.billing_account_id
WHERE
  eb.utilization < 20
  AND eb.pricing_model = 'on-demand'

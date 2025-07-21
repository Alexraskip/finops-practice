-- Calculate potential savings by comparing on-demand costs with estimated spot costs
SELECT
  ROUND(SUM(eb.cost), 2) AS on_demand_cost,                  -- Total on-demand cost rounded to 2 decimals
  ROUND(SUM(eb.cost) * 0.3, 2) AS estimated_spot_cost,      -- Estimated spot cost assuming 70% cheaper (30% of on-demand)
  ROUND(SUM(eb.cost) - SUM(eb.cost) * 0.3, 2) AS potential_savings  -- Potential savings if switched to spot instances
FROM
  `finops-practice.billing_data.exported_billing` eb        -- Billing data table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  eb.billing_account_id = r.billing_account_id               -- Join to get billing account reference (optional here)
WHERE
  eb.utilization < 20                                        -- Filter for low utilization resources
  AND eb.pricing_model = 'on-demand'                         -- Only consider on-demand pricing model

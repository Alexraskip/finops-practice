-- Spot vs on-demand cost comparison
SELECT
  pricing_model,
  SUM(cost) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY pricing_model
ORDER BY total_cost DESC;

-- Cost by resource type and environment
SELECT
  environment,
  sku_description,
  SUM(cost) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY environment, sku_description
ORDER BY total_cost DESC;

-- Estimate savings if moved low-utilization workloads to Spot
SELECT
  SUM(cost) AS on_demand_cost,
  SUM(cost) * 0.3 AS estimated_spot_cost, -- assume 70% cheaper
  SUM(cost) - SUM(cost) * 0.3 AS potential_savings
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization < 20 AND pricing_model = 'on-demand';

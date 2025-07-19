-- Spot vs on-demand cost comparison
SELECT
  pricing_model,
  ROUND(SUM(cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY pricing_model
ORDER BY total_cost DESC;


-- Cost by resource type and environment
SELECT
  environment,
  sku_description,
  ROUND(SUM(cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY environment, sku_description
ORDER BY total_cost DESC;


-- Estimate savings if moved low-utilization workloads to Spot
SELECT
  ROUND(SUM(cost), 2) AS on_demand_cost,
  ROUND(SUM(cost) * 0.3, 2) AS estimated_spot_cost,  -- assume 70% cheaper
  ROUND(SUM(cost) - SUM(cost) * 0.3, 2) AS potential_savings
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization < 20 AND pricing_model = 'on-demand';

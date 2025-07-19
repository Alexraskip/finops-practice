-- Find idle resources (utilization = 0)
SELECT
  project_id,
  service_description,
  sku_description,
  usage_start_time,
  cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization = 0
ORDER BY cost DESC
LIMIT 50;

-- Find underutilized resources (utilization < 20%)
SELECT
  project_id,
  service_description,
  sku_description,
  AVG(utilization) AS avg_utilization,
  SUM(cost) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization < 20
GROUP BY project_id, service_description, sku_description
ORDER BY avg_utilization ASC
LIMIT 50;

-- Oversized resources (resource.size > threshold & low utilization)
SELECT
  project_id,
  sku_description,
  resource_size,
  AVG(utilization) AS avg_utilization,
  SUM(cost) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE resource_size > 8 AND utilization < 30
GROUP BY project_id, sku_description, resource_size
ORDER BY total_cost DESC
LIMIT 50;

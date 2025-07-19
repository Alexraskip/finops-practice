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
  ROUND(AVG(utilization), 2) AS avg_utilization,
  ROUND(SUM(cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization < 20
GROUP BY project_id, service_description, sku_description
ORDER BY avg_utilization ASC
LIMIT 50;


-- Oversized resources (mapped resource_size label > threshold & low utilization)
WITH prepared AS (
  SELECT
    project_id,
    sku_description,
    CASE resource_size
      WHEN 'Small' THEN 2
      WHEN 'Medium' THEN 4
      WHEN 'Large' THEN 8
    END AS resource_size_num,
    utilization,
    cost
  FROM `finops-practice.billing_data.exported_billing`
)
SELECT
  project_id,
  sku_description,
  resource_size_num,
  ROUND(AVG(utilization), 2) AS avg_utilization,
  ROUND(SUM(cost), 2) AS total_cost
FROM prepared
WHERE resource_size_num > 4 AND utilization < 30
GROUP BY project_id, sku_description, resource_size_num
ORDER BY total_cost DESC
LIMIT 50;

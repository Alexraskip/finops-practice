-- 1️⃣ Cost visibility by project and month
SELECT
  project_id,
  invoice_month,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY project_id, invoice_month
ORDER BY invoice_month DESC, total_cost DESC
LIMIT 50;


-- 2️⃣ Cost by department and environment
SELECT
  labels_department,
  environment,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY labels_department, environment
ORDER BY total_cost DESC;


-- 3️⃣ Identify potential idle/underutilized resources (utilization < 20%)
SELECT
  project_id,
  service_description,
  sku_description,
  ROUND(AVG(utilization), 2) AS avg_utilization,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE utilization < 20
GROUP BY project_id, service_description, sku_description
ORDER BY avg_utilization ASC
LIMIT 100;


-- 4️⃣ Detect cost spikes (usage_type = 'spike')
SELECT
  project_id,
  invoice_month,
  ROUND(SUM(cost)) AS spike_cost
FROM
  `finops-practice.billing_data.exported_billing`
WHERE usage_type = 'spike'
GROUP BY project_id, invoice_month
ORDER BY spike_cost DESC
LIMIT 50;


-- 5️⃣ Cost by pricing model
SELECT
  pricing_model,
  ROUND(SUM(cost)) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY pricing_model
ORDER BY total_cost DESC;


-- 6️⃣ Monthly cost forecast (simple linear projection example)
WITH monthly_costs AS (
  SELECT
    invoice_month,
    ROUND(SUM(cost)) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY invoice_month
)
SELECT
  invoice_month,
  total_cost,
  LEAD(total_cost) OVER (ORDER BY invoice_month) AS next_month_cost,
  (LEAD(total_cost) OVER (ORDER BY invoice_month) - total_cost) AS cost_diff
FROM
  monthly_costs
ORDER BY invoice_month DESC
LIMIT 12;

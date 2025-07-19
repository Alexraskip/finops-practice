-- Identify projects/departments over a synthetic monthly budget threshold
WITH monthly_costs AS (
  SELECT
    labels_department,
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY labels_department, project_id, invoice_month
)
SELECT
  labels_department,
  project_id,
  invoice_month,
  total_cost,
  -- Assume synthetic budget threshold per project per month
  17 AS budget_threshold,
  CASE
    WHEN total_cost > 17 THEN 'OVER BUDGET'
    ELSE 'OK'
  END AS budget_status
FROM monthly_costs
ORDER BY invoice_month DESC, total_cost DESC;

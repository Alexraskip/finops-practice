-- Anomaly detection of monthly cost spikes by project
WITH monthly_costs AS (
  SELECT
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY project_id, invoice_month
),
moving_avg AS (
  SELECT
    project_id,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (
      PARTITION BY project_id 
      ORDER BY invoice_month 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3mo
  FROM monthly_costs
)
SELECT
  project_id,
  invoice_month,
  ROUND(total_cost, 2) AS total_cost,
  ROUND(moving_avg_3mo, 2) AS moving_avg_3mo,
  ROUND(total_cost - moving_avg_3mo, 2) AS deviation,
  CASE
    WHEN total_cost > 1.5 * moving_avg_3mo THEN 'ANOMALY'
    ELSE 'NORMAL'
  END AS anomaly_flag
FROM moving_avg
WHERE total_cost > 0
ORDER BY deviation DESC
LIMIT 50;

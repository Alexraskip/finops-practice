-- Anomaly detection of monthly cost spikes by project
WITH monthly_costs AS (
  SELECT
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.synthetic_billing_data`
  GROUP BY project_id, invoice_month
),
moving_avg AS (
  SELECT
    project_id,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (PARTITION BY project_id ORDER BY invoice_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3mo
  FROM monthly_costs
)
SELECT
  project_id,
  invoice_month,
  total_cost,
  moving_avg_3mo,
  total_cost - moving_avg_3mo AS deviation,
  CASE
    WHEN total_cost > 1.5 * moving_avg_3mo THEN 'ANOMALY'
    ELSE 'NORMAL'
  END AS anomaly_flag
FROM moving_avg
WHERE total_cost > 0
ORDER BY deviation DESC
LIMIT 50;

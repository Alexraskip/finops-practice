-- Detect daily cost spikes: cost > 500 USD
WITH daily_costs AS (
  SELECT
    project_id,
    DATE(usage_start_time) AS day,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY project_id, day
)
SELECT
  project_id,
  day,
  ROUND(total_cost, 2) AS total_cost,
  CASE
    WHEN total_cost > 500 THEN 'ALERT: High Daily Spend'
    ELSE 'OK'
  END AS alert_status
FROM daily_costs
ORDER BY day DESC, total_cost DESC
LIMIT 100;

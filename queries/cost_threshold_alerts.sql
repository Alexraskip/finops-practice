WITH daily_costs AS (
  SELECT
    billing_account_id,
    project_id,
    DATE(usage_start_time) AS day,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY billing_account_id, project_id, day
)
SELECT
  d.project_id,
  d.day,
  ROUND(d.total_cost, 2) AS total_cost,
  CASE
    WHEN d.total_cost > 500 THEN 'ALERT: High Daily Spend'
    ELSE 'OK'
  END AS alert_status,
  bcr.customer_name,
  bcr.business_unit,
  bcr.product_team
FROM
  daily_costs d
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` bcr
ON
  d.billing_account_id = bcr.billing_account_id
ORDER BY
  d.day DESC,
  d.total_cost DESC
LIMIT 100;

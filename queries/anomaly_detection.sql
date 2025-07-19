WITH monthly_costs AS (
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY billing_account_id, project_id, invoice_month
),
moving_avg AS (
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (
      PARTITION BY billing_account_id, project_id 
      ORDER BY invoice_month 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3mo
  FROM monthly_costs
),
anomalies AS (
  SELECT
    billing_account_id,
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
)
SELECT
  r.customer_name,
  r.business_unit,
  r.product_team,
  a.billing_account_id,
  a.project_id,
  a.invoice_month,
  a.total_cost,
  a.moving_avg_3mo,
  a.deviation,
  a.anomaly_flag
FROM
  anomalies a
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  a.billing_account_id = r.billing_account_id
WHERE
  a.anomaly_flag = 'ANOMALY'
ORDER BY
  a.deviation DESC
LIMIT 50;

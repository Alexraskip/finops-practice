-- Forecast monthly cost per project_id, with customer and business info
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
      PARTITION BY project_id
      ORDER BY invoice_month 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3mo
  FROM monthly_costs
)
SELECT
  r.customer_name,
  r.business_unit,
  r.product_team,
  m.billing_account_id,
  m.project_id,
  m.invoice_month,
  ROUND(m.total_cost, 2) AS total_cost,
  ROUND(m.moving_avg_3mo, 2) AS moving_avg_3mo,
  ROUND(LEAD(m.moving_avg_3mo) OVER (PARTITION BY m.project_id ORDER BY invoice_month), 2) AS forecast_next_month
FROM
  moving_avg m
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  m.billing_account_id = r.billing_account_id
ORDER BY
  invoice_month DESC, total_cost DESC
LIMIT 100;

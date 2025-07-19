WITH monthly_costs AS (
  ...
),
joined AS (
  ...
),
moving_avg AS (
  ...
)
SELECT
  customer_name,
  business_unit,
  product_team,
  billing_account_id,
  invoice_month,
  ROUND(total_cost, 2) AS total_cost,
  ROUND(moving_avg_3mo, 2) AS moving_avg_3mo,
  ROUND(
    LEAD(moving_avg_3mo) OVER (
      PARTITION BY billing_account_id
      ORDER BY invoice_month
    ), 2
  ) AS forecast_next_month
FROM moving_avg
ORDER BY customer_name, invoice_month DESC
LIMIT 100

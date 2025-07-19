-- Monthly cost forecasting with 3-month moving average
WITH monthly_costs AS (
  SELECT
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY invoice_month
  ORDER BY invoice_month
),
moving_avg AS (
  SELECT
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (ORDER BY invoice_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3mo
  FROM monthly_costs
)
SELECT
  invoice_month,
  total_cost,
  moving_avg_3mo,
  LEAD(moving_avg_3mo) OVER (ORDER BY invoice_month) AS forecast_next_month
FROM moving_avg
ORDER BY invoice_month DESC
LIMIT 12;

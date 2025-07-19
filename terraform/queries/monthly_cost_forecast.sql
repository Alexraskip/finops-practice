-- Forecast monthly cost per customer, business unit, and project team
WITH monthly_costs AS (
  SELECT
    b.invoice_month,
    b.billing_account_id,
    SUM(b.cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing` b
  GROUP BY b.invoice_month, b.billing_account_id
),
joined AS (
  SELECT
    m.invoice_month,
    m.billing_account_id,
    r.customer_name,
    r.business_unit,
    r.product_team,
    m.total_cost
  FROM
    monthly_costs m
  LEFT JOIN
    `finops-practice.billing_data.billing_account_reference` r
  ON
    m.billing_account_id = r.billing_account_id
),
moving_avg AS (
  SELECT
    invoice_month,
    billing_account_id,
    customer_name,
    business_unit,
    product_team,
    total_cost,
    -- Calculate 3-month moving average for each customer/account
    AVG(total_cost) OVER (
      PARTITION BY billing_account_id
      ORDER BY invoice_month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3mo
  FROM joined
)
SELECT
  customer_name,
  business_unit,
  product_team,
  billing_account_id,
  invoice_month,
  ROUND(total_cost, 2) AS total_cost,
  ROUND(moving_avg_3mo, 2) AS moving_avg_3mo,
  -- Forecast next month: look ahead from moving average
  ROUND(
    LEAD(moving_avg_3mo) OVER (
      PARTITION BY billing_account_id
      ORDER BY invoice_month
    ), 2
  ) AS forecast_next_month
FROM moving_avg
ORDER BY customer_name, invoice_month DESC
LIMIT 100;

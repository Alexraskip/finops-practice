-- Calculate and forecast monthly costs per project with associated customer and business details

WITH monthly_costs AS (
  -- Aggregate total costs per billing account, project, and invoice month
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
  -- Calculate 3-month moving average of total costs per project, ordered by invoice month
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (
      PARTITION BY project_id
      ORDER BY invoice_month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW  -- Include current and previous 2 months for average
    ) AS moving_avg_3mo
  FROM monthly_costs
)

SELECT
  r.customer_name,                             -- Customer name from reference table
  r.business_unit,                            -- Business unit associated with billing account
  r.product_team,                             -- Product team associated with billing account
  m.billing_account_id,                       -- Billing account identifier
  m.project_id,                              -- Project identifier
  m.invoice_month,                           -- Invoice month (period of billing)
  ROUND(m.total_cost, 2) AS total_cost,     -- Rounded total cost for the month
  ROUND(m.moving_avg_3mo, 2) AS moving_avg_3mo,  -- Rounded 3-month moving average cost
  ROUND(
    LEAD(m.moving_avg_3mo) OVER (
      PARTITION BY m.project_id              -- Forecast next month based on moving average trend
      ORDER BY invoice_month
    ), 2
  ) AS forecast_next_month
FROM
  moving_avg m
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  m.billing_account_id = r.billing_account_id -- Join with reference data for customer/business info
ORDER BY
  invoice_month DESC, total_cost DESC          -- Sort by latest invoice month and highest cost
LIMIT 100;                                     -- Limit output to top 100 results

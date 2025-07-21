-- ====================================================================
-- Query: Monthly Costs with 3-Month Moving Average and Forecast
-- Purpose: Calculate monthly costs per billing account and project,
--          compute a 3-month moving average, and forecast the next month’s cost.
-- ====================================================================

WITH monthly_costs AS (
  -- Step 1: Aggregate raw billing data by billing account, project, and invoice month
  --          to get total cost per month.
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY
    billing_account_id,
    project_id,
    invoice_month
),
joined AS (
  -- Step 2: Join monthly costs with reference data to enrich with customer details.
  SELECT
    mc.billing_account_id,
    mc.project_id,
    mc.invoice_month,
    mc.total_cost,
    r.customer_name,
    r.business_unit,
    r.product_team
  FROM
    monthly_costs mc
  LEFT JOIN
    `finops-practice.billing_data.billing_account_reference` r
  ON
    mc.billing_account_id = r.billing_account_id
),
moving_avg AS (
  -- Step 3: Calculate a 3-month moving average of the total cost per billing account.
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    total_cost,
    customer_name,
    business_unit,
    product_team,
    AVG(total_cost) OVER (
      PARTITION BY billing_account_id
      ORDER BY invoice_month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3mo
  FROM joined
)

SELECT
  customer_name,                        -- Customer name from reference data
  business_unit,                       -- Business unit name
  product_team,                       -- Product team responsible
  billing_account_id,                  -- Billing account identifier
  invoice_month,                      -- Invoice month (date)
  ROUND(total_cost, 2) AS total_cost, -- Monthly total cost, rounded to 2 decimals
  ROUND(moving_avg_3mo, 2) AS moving_avg_3mo,  -- 3-month moving average of cost
  ROUND(
    LEAD(moving_avg_3mo) OVER (       -- Forecast next month’s moving average cost using lead window function
      PARTITION BY billing_account_id
      ORDER BY invoice_month
    ), 2
  ) AS forecast_next_month
FROM moving_avg
ORDER BY
  customer_name,
  invoice_month DESC                  -- Sort latest invoice month first per customer
LIMIT 100;                          -- Limit output to top 100 rows

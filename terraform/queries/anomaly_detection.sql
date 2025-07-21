-- Calculate moving average and detect cost anomalies by project over time

-- Step 1: Calculate total monthly cost per billing account & project
WITH monthly_costs AS (
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY
    billing_account_id, project_id, invoice_month
),

-- Step 2: Compute 3-month moving average of total costs per billing account & project
moving_avg AS (
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (
      PARTITION BY billing_account_id, project_id    -- compute average separately for each billing account & project
      ORDER BY invoice_month                          -- in chronological order by month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW       -- average over current + 2 previous months
    ) AS moving_avg_3mo
  FROM
    monthly_costs
),

-- Step 3: Identify anomalies based on deviation from moving average
anomalies AS (
  SELECT
    billing_account_id,
    project_id,
    invoice_month,
    ROUND(total_cost, 2) AS total_cost,
    ROUND(moving_avg_3mo, 2) AS moving_avg_3mo,
    ROUND(total_cost - moving_avg_3mo, 2) AS deviation,
    CASE
      WHEN total_cost > 1.5 * moving_avg_3mo THEN 'ANOMALY'   -- mark as anomaly if cost > 1.5x moving average
      ELSE 'NORMAL'
    END AS anomaly_flag
  FROM
    moving_avg
  WHERE
    total_cost > 0    -- exclude zero-cost months
)

-- Step 4: Join anomalies with billing account reference to add metadata and select top 50 anomalies
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
  a.anomaly_flag = 'ANOMALY'    -- only show rows marked as anomalies
ORDER BY
  a.deviation DESC              -- order by largest deviation first
LIMIT 50;                       -- return top 50 anomalies

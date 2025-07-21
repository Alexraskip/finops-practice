-- Budget alert query: compare actual monthly cost vs. budget threshold and flag overages

-- Step 1: Aggregate total monthly cost per billing account, department, and project
WITH monthly_costs AS (
  SELECT
    billing_account_id,
    labels_department,           -- department label from resource labels
    project_id,
    invoice_month,
    SUM(cost) AS total_cost      -- sum of costs for that month
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY
    billing_account_id,
    labels_department,
    project_id,
    invoice_month
),

-- Step 2: Check against a static budget threshold and flag status
budget_check AS (
  SELECT
    billing_account_id,
    labels_department,
    project_id,
    invoice_month,
    total_cost,
    17 AS budget_threshold,                          -- hardcoded monthly budget threshold (can be parameterized)
    CASE
      WHEN total_cost > 17 THEN 'OVER BUDGET'        -- flag if cost exceeds threshold
      ELSE 'OK'
    END AS budget_status
  FROM
    monthly_costs
)

-- Step 3: Join with billing account metadata and return final report
SELECT
  bcr.customer_name,
  bcr.business_unit,
  bcr.product_team,
  bc.labels_department,
  bc.project_id,
  bc.invoice_month,
  bc.total_cost,
  bc.budget_threshold,
  bc.budget_status
FROM
  budget_check bc
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` bcr
ON
  bc.billing_account_id = bcr.billing_account_id
ORDER BY
  bc.invoice_month DESC,        -- latest month first
  bc.total_cost DESC;           -- within month, show highest spend first

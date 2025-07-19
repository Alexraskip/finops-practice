WITH monthly_costs AS (
  SELECT
    billing_account_id,
    labels_department,
    project_id,
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY
    billing_account_id,
    labels_department,
    project_id,
    invoice_month
),
budget_check AS (
  SELECT
    billing_account_id,
    labels_department,
    project_id,
    invoice_month,
    total_cost,
    17 AS budget_threshold,
    CASE
      WHEN total_cost > 17 THEN 'OVER BUDGET'
      ELSE 'OK'
    END AS budget_status
  FROM monthly_costs
)
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
  `finops-practice.billing.data.billing_account_reference` bcr
ON
  bc.billing_account_id = bcr.billing_account_id
ORDER BY
  bc.invoice_month DESC,
  bc.total_cost DESC;

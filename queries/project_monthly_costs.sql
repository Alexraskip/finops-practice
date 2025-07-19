SELECT
  b.project_id,
  b.invoice_month,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  ROUND(SUM(b.cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  b.billing_account_id = r.billing_account_id
GROUP BY
  b.project_id,
  b.invoice_month,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  b.invoice_month DESC,
  total_cost DESC;

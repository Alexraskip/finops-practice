SELECT
  eb.project_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  COUNT(*) AS records_missing_label
FROM
  `finops-practice.billing_data.exported_billing` eb
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
  ON eb.billing_account_id = r.billing_account_id
WHERE eb.labels_cost_center IS NULL
GROUP BY
  eb.project_id, r.customer_name, r.business_unit, r.product_team
ORDER BY
  records_missing_label DESC
LIMIT 50

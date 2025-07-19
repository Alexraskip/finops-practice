SELECT
  eb.labels_department,
  COUNTIF(eb.labels_cost_center IS NULL) AS missing,
  COUNT(*) AS total,
  ROUND(100 * (1 - COUNTIF(eb.labels_cost_center IS NULL)/COUNT(*)), 2) AS coverage_pct,
  r.customer_name,
  r.business_unit,
  r.product_team
FROM
  `finops-practice.billing_data.exported_billing` eb
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON eb.billing_account_id = r.billing_account_id
GROUP BY
  eb.labels_department, r.customer_name, r.business_unit, r.product_team
ORDER BY
  coverage_pct ASC;

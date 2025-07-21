-- Calculate cost center label coverage per department with customer info
SELECT
  eb.labels_department,                          -- Department label
  COUNTIF(eb.labels_cost_center IS NULL) AS missing,  -- Count of records missing cost center label
  COUNT(*) AS total,                            -- Total number of records
  ROUND(100 * (1 - COUNTIF(eb.labels_cost_center IS NULL)/COUNT(*)), 2) AS coverage_pct,  -- Percentage of records with cost center label
  r.customer_name,                             -- Customer name from reference table
  r.business_unit,                             -- Business unit from reference table
  r.product_team                              -- Product team from reference table
FROM
  `finops-practice.billing_data.exported_billing` eb    -- Billing data table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- Reference table for additional metadata
ON eb.billing_account_id = r.billing_account_id
GROUP BY
  eb.labels_department, r.customer_name, r.business_unit, r.product_team  -- Group by department and customer info
ORDER BY
  coverage_pct ASC;                              -- Order by coverage percentage ascending to highlight low coverage departments

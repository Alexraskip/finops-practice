SELECT
  eb.billing_account_id,                      -- Billing account identifier
  eb.project_id,                             -- Project identifier
  r.customer_name,                           -- Customer name (enriched from reference table)
  r.business_unit,                           -- Business unit name
  r.product_team,                            -- Product team responsible
  COUNT(*) AS records_missing_label          -- Number of billing records missing the cost_center label
FROM
  `finops-practice.billing_data.exported_billing` eb   -- Main billing export table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- Join to enrich with metadata
  ON eb.billing_account_id = r.billing_account_id
WHERE
  eb.labels_cost_center IS NULL               -- Filter for records where the cost_center label is missing
GROUP BY
  eb.billing_account_id,
  eb.project_id,
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  records_missing_label DESC                   -- Sort by projects with the most missing labels first
LIMIT 50;                                      -- Limit output to top 50 projects

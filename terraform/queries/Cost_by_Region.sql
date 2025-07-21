-- Query: Summarize total cost per billing account by region,
-- enriched with customer, business unit, and product team information.

SELECT
  b.billing_account_id,                    -- unique billing account ID from billing data
  r.customer_name,                         -- customer name from the reference table
  r.business_unit,                         -- business unit from the reference table
  r.product_team,                          -- product team from the reference table
  r.region,                               -- region from the reference table
  ROUND(SUM(b.cost), 2) AS total_cost      -- total cost per group, rounded to 2 decimal places
FROM
  `finops-practice.billing_data.exported_billing` b          -- main billing data source
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r -- enrich with customer metadata
ON
  b.billing_account_id = r.billing_account_id
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  r.region
ORDER BY
  total_cost DESC;                          -- list highest costs first

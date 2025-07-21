-- Aggregate total costs per project per invoice month, including customer and business details

SELECT
  b.project_id,                             -- Project identifier
  b.invoice_month,                         -- Billing invoice month
  r.billing_account_id,                    -- Billing account identifier
  r.customer_name,                         -- Customer name from reference data
  r.business_unit,                         -- Business unit associated with billing account
  r.product_team,                         -- Product team associated with billing account
  ROUND(SUM(b.cost), 2) AS total_cost     -- Total cost for the project in the invoice month, rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` b
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  b.billing_account_id = r.billing_account_id  -- Join to enrich billing data with customer/business info
GROUP BY
  b.project_id,
  b.invoice_month,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  b.invoice_month DESC,       -- Order results by the most recent invoice month first
  total_cost DESC;            -- Then by highest total cost

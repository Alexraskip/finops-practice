SELECT
  r.billing_account_id,          -- Unique identifier for the billing account
  b.labels_department,           -- Department label from resource labels
  r.customer_name,               -- Customer name from reference metadata
  r.business_unit,               -- Business unit from reference metadata
  r.product_team,                -- Product team from reference metadata
  b.invoice_month,               -- Billing month for cost aggregation (YYYY-MM format)
  ROUND(SUM(b.cost), 2) AS total_cost  -- Total cost aggregated and rounded to 2 decimal places
FROM
  finops-practice.billing_data.exported_billing b   -- Main billing data table containing cost and labels
LEFT JOIN
  finops-practice.billing_data.billing_account_reference r  -- Reference table providing customer metadata
ON
  b.billing_account_id = r.billing_account_id    -- Join on billing account ID to enrich billing data with metadata
-- Removed invoice_month filter to include all months
GROUP BY
  r.billing_account_id,           -- Group by billing account to aggregate costs per account
  b.labels_department,            -- Group by department label for department-level cost breakdown
  r.customer_name,                -- Group by customer name for clear attribution
  r.business_unit,                -- Group by business unit to organize cost by business segments
  r.product_team,                 -- Group by product team for granular product-level insights
  b.invoice_month                 -- Group by invoice month to ensure aggregation is per billing cycle
ORDER BY
  total_cost DESC;                -- Order results by descending total cost to highlight highest spenders first

-- ====================================================================
-- Query: Zero Utilization Resources Report
-- Purpose: Identify resources that incurred cost but had zero utilization.
--          Helps in spotting completely unused resources to optimize cost.
-- ====================================================================

SELECT
  b.billing_account_id,                        -- billing account ID
  r.customer_name,                             -- customer name (enriched)
  r.business_unit,                             -- business unit name
  r.product_team,                              -- product team name
  b.project_id,                                -- project where resource runs
  b.service_description,                        -- GCP service name (e.g., Compute Engine)
  b.sku_description,                            -- SKU (pricing unit) description
  b.usage_start_time,                          -- when usage started
  ROUND(b.cost, 2) AS cost                     -- resource cost rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` b   -- billing export table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- enrich billing account metadata
ON
  b.billing_account_id = r.billing_account_id
WHERE
  b.utilization = 0                            -- only completely unused resources
ORDER BY
  cost DESC                                    -- most expensive unused resources first
LIMIT 50;                                      -- limit to top 50 results

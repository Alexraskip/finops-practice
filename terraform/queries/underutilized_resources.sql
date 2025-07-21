-- Query to identify resources with low utilization and their associated costs
SELECT
  b.billing_account_id,                -- Billing account identifier
  r.customer_name,                     -- Customer name from reference table
  r.business_unit,                     -- Business unit from reference table
  r.product_team,                      -- Product team from reference table
  b.project_id,                       -- Project identifier
  b.service_description,               -- Description of the service/resource
  b.sku_description,                   -- SKU description of the resource
  ROUND(AVG(b.utilization), 2) AS avg_utilization,  -- Average utilization percentage of the resource, rounded to 2 decimals
  ROUND(SUM(b.cost), 2) AS total_cost               -- Total cost incurred by the resource, rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` b  -- Billing export table containing usage and cost details
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- Reference table for additional metadata about billing accounts
ON b.billing_account_id = r.billing_account_id
WHERE
  b.utilization < 20                    -- Filter for resources with utilization below 20%
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.service_description,
  b.sku_description
ORDER BY
  avg_utilization ASC                   -- Order results by ascending average utilization (lowest first)
LIMIT 50;                              -- Limit to top 50 results with lowest utilization

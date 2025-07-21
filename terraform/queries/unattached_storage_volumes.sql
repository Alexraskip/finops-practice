-- Query to identify unattached storage volumes and their costs
SELECT
  b.billing_account_id,        -- Billing account identifier
  r.customer_name,             -- Customer name from reference table
  r.business_unit,             -- Business unit from reference table
  r.product_team,              -- Product team from reference table
  b.project_id,                -- Project identifier
  b.resource_id,               -- Resource identifier (storage volume ID)
  b.service_description,       -- Description of the service
  b.sku_description,           -- SKU description
  ROUND(SUM(b.cost), 2) AS total_cost  -- Total cost of the unattached storage volume, rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` b   -- Billing export table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- Reference table for additional metadata
ON b.billing_account_id = r.billing_account_id
WHERE
  b.resource_type = 'Storage Volume'   -- Filter for storage volume resources only
  AND b.attached = FALSE                -- Filter for unattached volumes only
GROUP BY
  b.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  b.project_id,
  b.resource_id,
  b.service_description,
  b.sku_description
ORDER BY total_cost DESC                  -- Order results by descending total cost
LIMIT 50;                                -- Limit to top 50 most costly unattached volumes

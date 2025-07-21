-- Prepare a dataset with numeric resource sizes and relevant billing info
WITH prepared AS (
  SELECT
    billing_account_id,       -- Billing account identifier
    project_id,               -- Project identifier
    sku_description,          -- Description of the SKU (resource type)
    -- Convert resource_size label to a numeric value for easier filtering/comparison
    CASE resource_size
      WHEN 'Small' THEN 2
      WHEN 'Medium' THEN 4
      WHEN 'Large' THEN 8
      ELSE 0                  -- Default to 0 if resource_size is unrecognized
    END AS resource_size_num,
    utilization,              -- Utilization percentage of the resource
    cost                      -- Cost associated with the resource
  FROM `finops-practice.billing_data.exported_billing`
)

SELECT
  p.billing_account_id,       -- Billing account identifier
  r.customer_name,            -- Customer name from reference data
  r.business_unit,            -- Business unit name
  r.product_team,             -- Product team name
  p.project_id,               -- Project identifier
  p.sku_description,          -- SKU description
  p.resource_size_num,        -- Numeric resource size value
  ROUND(AVG(p.utilization), 2) AS avg_utilization,  -- Average utilization rounded to 2 decimals
  ROUND(SUM(p.cost), 2) AS total_cost               -- Total cost rounded to 2 decimals
FROM prepared p
LEFT JOIN `finops-practice.billing_data.billing_account_reference` r
  ON p.billing_account_id = r.billing_account_id   -- Join to enrich with customer info
WHERE
  p.resource_size_num > 4     -- Filter for resources larger than Medium (i.e., Large and above)
  AND p.utilization < 30      -- Filter for resources with utilization below 30% (underutilized)
GROUP BY
  p.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team,
  p.project_id,
  p.sku_description,
  p.resource_size_num
ORDER BY
  total_cost DESC             -- Order results by total cost in descending order
LIMIT 50                      -- Limit output to top 50 records

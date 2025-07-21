-- Summarize resources with average utilization less than 50%, showing cost and business info

WITH usage_summary AS (
  SELECT
    billing_account_id,         -- Billing account identifier
    project_id,                 -- Project identifier
    service_description,        -- Description of the GCP service
    sku_description,            -- SKU description of the resource
    AVG(utilization) AS avg_utilization, -- Average utilization percentage of the resource
    SUM(cost) AS total_cost     -- Total cost accumulated for this resource
  FROM
    `finops-practice.billing_data.exported_billing`  -- Billing data source
  GROUP BY
    billing_account_id, project_id, service_description, sku_description
  HAVING
    avg_utilization < 50       -- Filter to resources with average utilization below 50%
)

SELECT
  u.billing_account_id,
  r.customer_name,             -- Customer name linked to billing account
  r.business_unit,             -- Business unit linked to billing account
  r.product_team,              -- Product team linked to billing account
  u.project_id,
  u.service_description,
  u.sku_description,
  ROUND(u.avg_utilization, 2) AS avg_utilization,   -- Rounded average utilization
  ROUND(u.total_cost, 2) AS total_cost              -- Rounded total cost
FROM
  usage_summary u
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
  ON u.billing_account_id = r.billing_account_id   -- Join to get customer and business info
ORDER BY
  total_cost DESC       -- Order by highest total cost descending
LIMIT 50                -- Limit to top 50 results

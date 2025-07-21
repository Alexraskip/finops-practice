-- Summarize total costs by environment and SKU, with customer and business unit details

SELECT
  eb.environment,            -- Environment label (e.g., production, staging)
  eb.sku_description,        -- SKU description for the resource/service
  r.customer_name,           -- Customer name from reference table
  r.business_unit,           -- Business unit associated with the billing account
  r.product_team,            -- Product team associated with the billing account
  ROUND(SUM(eb.cost), 2) AS total_cost  -- Total cost summed and rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` eb  -- Billing data table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r  -- Reference table for business info
  ON eb.billing_account_id = r.billing_account_id
GROUP BY
  eb.environment, eb.sku_description, r.customer_name, r.business_unit, r.product_team
ORDER BY
  total_cost DESC  -- Order results by highest total cost first

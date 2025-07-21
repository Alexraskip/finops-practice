-- Aggregate total cost by service and SKU, including customer and business info

SELECT
  b.service_description,         -- Description of the GCP service
  b.sku_description,             -- SKU description for the service/resource
  r.billing_account_id,          -- Billing account ID associated with the cost
  r.customer_name,               -- Customer name linked to billing account
  r.business_unit,               -- Business unit linked to billing account
  r.product_team,                -- Product team linked to billing account
  ROUND(SUM(b.cost), 2) AS total_cost  -- Total cost rounded to 2 decimal places
FROM
  `finops-practice.billing_data.exported_billing` b  -- Billing data table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  b.billing_account_id = r.billing_account_id          -- Join to get customer/business metadata
GROUP BY
  b.service_description,
  b.sku_description,
  r.billing_account_id,
  r.customer_name,
  r.business_unit,
  r.product_team
ORDER BY
  total_cost DESC;                                      -- Order results by descending total cost

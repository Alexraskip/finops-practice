-- Summarize total costs grouped by pricing model (e.g., on-demand, spot, reserved)
SELECT
  eb.pricing_model,                -- Pricing model of the resource
  ROUND(SUM(eb.cost), 2) AS total_cost  -- Total cost per pricing model, rounded to 2 decimals
FROM
  `finops-practice.billing_data.exported_billing` eb       -- Billing data table
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  eb.billing_account_id = r.billing_account_id              -- Join to billing account reference for additional metadata if needed
GROUP BY
  eb.pricing_model                                          -- Group results by pricing model
ORDER BY
  total_cost DESC                                           -- Order results by descending total cost
;

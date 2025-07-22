-- Forecast monthly cost per project, service, and SKU, including customer and business information

WITH monthly_costs AS (
  -- Aggregate total cost per billing account, project, service, SKU, and invoice month
  SELECT
    billing_account_id,
    project_id,
    service_description,    -- The service being billed
    sku_description,        -- SKU description for detailed resource level
    invoice_month,
    SUM(cost) AS total_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY
    billing_account_id, project_id, service_description, sku_description, invoice_month
),

moving_avg AS (
  -- Calculate a 3-month moving average of the total cost for each project-service-SKU combo
  SELECT
    billing_account_id,
    project_id,
    service_description,
    sku_description,
    invoice_month,
    total_cost,
    AVG(total_cost) OVER (
      PARTITION BY project_id, service_description, sku_description   -- Partition by project, service, and SKU
      ORDER BY invoice_month                                          -- Order by invoice month chronologically
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW                        -- Include current and 2 previous months
    ) AS moving_avg_3mo
  FROM
    monthly_costs
)

SELECT
  r.customer_name,
  r.business_unit,
  r.product_team,
  m.billing_account_id,
  m.project_id,
  m.service_description,
  m.sku_description,
  m.invoice_month,
  ROUND(m.total_cost, 2) AS total_cost,               -- Actual monthly cost, rounded
  ROUND(m.moving_avg_3mo, 2) AS moving_avg_3mo,       -- 3-month moving average cost, rounded
  ROUND(
    LEAD(m.moving_avg_3mo) OVER (
      PARTITION BY m.project_id, m.service_description, m.sku_description
      ORDER BY invoice_month
    ), 2
  ) AS forecast_next_month                              -- Forecasted cost for next month based on moving average
FROM
  moving_avg m
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` r
ON
  m.billing_account_id = r.billing_account_id           -- Join to get customer and business unit info
ORDER BY
  invoice_month DESC, total_cost DESC                    -- Order by latest month and highest cost
LIMIT 100;                                               -- Limit to top 100 results

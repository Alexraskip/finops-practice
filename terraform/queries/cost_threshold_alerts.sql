-- Calculate daily costs per project and raise alerts if daily spend exceeds $500.

WITH daily_costs AS (
  SELECT
    billing_account_id,                          -- billing account identifier
    project_id,                                  -- GCP project ID
    DATE(usage_start_time) AS day,               -- extract the day from usage timestamp
    SUM(cost) AS total_cost                      -- total cost per project per day
  FROM
    `finops-practice.billing_data.exported_billing` -- main billing export table
  GROUP BY billing_account_id, project_id, day
)

SELECT
  d.project_id,                                  -- project ID
  d.day,                                         -- date of usage
  ROUND(d.total_cost, 2) AS total_cost,          -- round daily total cost to 2 decimals
  CASE
    WHEN d.total_cost > 500 THEN 'ALERT: High Daily Spend' -- flag if spend > $500
    ELSE 'OK'
  END AS alert_status,
  bcr.customer_name,                             -- enrich with customer name
  bcr.business_unit,                             -- enrich with business unit
  bcr.product_team                               -- enrich with product team
FROM
  daily_costs d
LEFT JOIN
  `finops-practice.billing_data.billing_account_reference` bcr
ON
  d.billing_account_id = bcr.billing_account_id
ORDER BY
  d.day DESC,                                    -- latest days first
  d.total_cost DESC                              -- highest spend first within the day
LIMIT 100;                                       -- limit to top 100 rows for reporting

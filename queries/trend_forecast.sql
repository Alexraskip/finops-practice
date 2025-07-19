-- Monthly cost trend
SELECT
  invoice_month,
  SUM(cost) AS monthly_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY invoice_month
ORDER BY invoice_month;

-- Simple next month forecast using last 2 months avg
WITH last_months AS (
  SELECT
    invoice_month,
    SUM(cost) AS monthly_cost
  FROM
    `finops-practice.billing_data.exported_billing`
  GROUP BY invoice_month
  ORDER BY invoice_month DESC
  LIMIT 2
)
SELECT
  'Forecast' AS type,
  ROUND(AVG(monthly_cost),2) AS predicted_next_month_cost
FROM last_months;

-- Year-over-year (YoY) cost by month
SELECT
  EXTRACT(YEAR FROM PARSE_DATE('%Y-%m', invoice_month)) AS year,
  EXTRACT(MONTH FROM PARSE_DATE('%Y-%m', invoice_month)) AS month,
  SUM(cost) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY year, month
ORDER BY year, month;

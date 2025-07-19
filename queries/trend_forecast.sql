-- 1️⃣ Monthly cost trend over time
SELECT
  invoice_month,
  ROUND(SUM(cost), 2) AS monthly_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY invoice_month
ORDER BY invoice_month;


-- 2️⃣ Simple next month forecast using average of last 2 months
WITH last_two_months AS (
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
  ROUND(AVG(monthly_cost), 2) AS predicted_next_month_cost
FROM last_two_months;


-- 3️⃣ Year-over-year (YoY) monthly cost analysis
SELECT
  EXTRACT(YEAR FROM PARSE_DATE('%Y-%m', invoice_month)) AS year,
  EXTRACT(MONTH FROM PARSE_DATE('%Y-%m', invoice_month)) AS month,
  ROUND(SUM(cost), 2) AS total_cost
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY year, month
ORDER BY year, month;

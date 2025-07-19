-- Identify missing cost_center label
SELECT
  project_id,
  COUNT(*) AS records_missing_label
FROM
  `finops-practice.billing_data.exported_billing`
WHERE labels_cost_center IS NULL
GROUP BY project_id
ORDER BY records_missing_label DESC
LIMIT 50;

-- Tagging completeness by department
SELECT
  labels_department,
  COUNTIF(labels_cost_center IS NULL) AS missing,
  COUNT(*) AS total,
  ROUND(100 * (1 - COUNTIF(labels_cost_center IS NULL)/COUNT(*)),2) AS coverage_pct
FROM
  `finops-practice.billing_data.exported_billing`
GROUP BY labels_department
ORDER BY coverage_pct ASC;

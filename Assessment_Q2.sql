SELECT 
  CASE
    WHEN avg_monthly_tx >= 10 THEN 'High Frequency'
    WHEN avg_monthly_tx >= 3 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_monthly_tx), 1) AS avg_transactions_per_month
FROM (
  SELECT 
    users_customuser.id AS customer_id,
    COUNT(savings_savingsaccount.id) / 12 AS avg_monthly_tx
  FROM users_customuser
  JOIN savings_savingsaccount 
    ON users_customuser.id = savings_savingsaccount.owner_id
  WHERE transaction_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  GROUP BY users_customuser.id
) AS monthly_avg
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
